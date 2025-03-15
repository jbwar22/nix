{ config, lib, pkgs, ... }:

with lib; with ns config ./.; let
  configfile = ageOrNull config "snapserver-shairport-config";
in {
  options = opt {
    enable = mkEnableOption "snapserver to control multi room audio";
    sink = mkEnableOption "custom pulse sync (broken)";
    shairport-port = mkOption {
      description = "port for shairport to listen on";
      type = with types; number;
      default = 5000;
    };
  };

  config = lib.mkIf cfg.enable {
    custom.nixos.behavior.shairport-support = {
      enable = mkDefault true;
      ports = [ cfg.shairport-port ];
    };

    systemd.services.snapserver.serviceConfig = {
      LoadCredential = mkIf (configfile != null) [
        "configfile:${configfile}"
      ];
    };

    services.snapserver = {
      enable = true;
      # codec = "flac";
      openFirewall = true;
      tcp = {
        enable = true;
      };
      http = {
        enable = true;
        docRoot = "${pkgs.snapweb}";
      };
      streams = {
        airplay = {
          type = "airplay";
          location = "${pkgs.shairport-sync}/bin/shairport-sync";
          query = {
            name = "AirPlay";
            devicename = "${config.custom.common.opts.host.hostname} snapcast";
            params = mkIf (configfile != null) "--configfile=\${CREDENTIALS_DIRECTORY}/configfile";
          };
        };
        pulse = mkIf cfg.sink {
          type = "pipe";
          location = "/run/snapserver/snapfifo";
          query = {
              mode = "create";
          };
        };
      };
    };

    services.pipewire.configPackages = mkIf cfg.sink [
      (pkgs.writeTextFile {
        name = "pipewire-snapcast-sink";
        text = ''
          pulse.cmd = [{ 
            cmd = "load-module"
            args = "module-pipe-sink"
            flags = [ "file=/run/snapserver/pulse" "sink_name=Snapcast" "format=s16le" "rate=48000" ]
          }]
        '';
        destination = "/share/pipewire/pipewire-pulse.conf.d/pipewire-snapcast-sink.conf";
      })
    ];
  };
}
