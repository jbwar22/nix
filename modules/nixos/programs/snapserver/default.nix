{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { nixos.programs.snapserver = ns; }) cfg opt;

  tcp_listen_port = 4953;
in
{
  options = opt {
    enable = mkEnableOption "snapserver to control multi room audio";
    
  };

  config = lib.mkIf cfg.enable {
    services.pipewire.configPackages = [
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

    networking.firewall.allowedTCPPorts = [ tcp_listen_port ];
    services.snapserver = {
      enable = true;
      codec = "flac";
      tcp.enable = true;
      http = {
        enable = true;
        docRoot = "${pkgs.snapcast}/share/snapserver/snapweb";
      };
      openFirewall = true;
      sendToMuted = true;
      streams = {
        airplay = {
          type = "airplay";
          location = "${pkgs.shairplay}/bin/shairplay";
        };
        pulse = {
          type = "pipe";
          location = "/run/snapserver/snapfifo";
          query = {
              mode = "create";
          };
        };
        tcp = {
          type = "tcp";
          location = "0.0.0.0";
          query = {
            name = "snapserver";
            mode = "server";
            port = "${builtins.toString tcp_listen_port}";
          };
        };
      };
    };

  };
}
