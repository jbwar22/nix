{ config, lib, pkgs, ... }:

with lib; with ns config ./.; let
  configfile = ageOrNull config "snapserver-shairport-config";
  admins = getAdmins config.custom.common.opts.host.users;
in {
  options = opt {
    enable = mkEnableOption "snapserver to control multi room audio";
    sink = mkOption {
      description = "custom pulse sync";
      type = with types; bool;
      default = true;
    };
    shairport-port = mkOption {
      description = "port for shairport to listen on";
      type = with types; number;
      default = 5000;
    };
  };

  config = lib.mkIf cfg.enable ({
    custom.nixos.behavior.shairport-support = {
      enable = mkDefault true;
      ports = [ cfg.shairport-port ];
    };

    # override systemd service
    systemd.services.snapserver.serviceConfig = {
      LoadCredential = mkIf (configfile != null) [
        "configfile:${configfile}"
      ];
    };

    # override firewall
    # use nixos-firewall-tool open 1780 to open http port temporarily
    # use nixos-firewall-tool reset to close when done
    networking.firewall.allowedTCPPorts = [ config.services.snapserver.port ];

    services.snapserver = {
      enable = true;
      openFirewall = false;
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
            devicename = "${capitalizeDashedString config.custom.common.opts.host.hostname} Snapcast";
            params = let
              params = singleton "--port=${toString cfg.shairport-port}"
                ++ optional (configfile != null) "--configfile=\${CREDENTIALS_DIRECTORY}/configfile";
            in concatStringsSep " " params;
          };
        };
        pulse = mkIf cfg.sink {
          type = "pipe";
          location = "/run/snapserver/fifo";
          query = {
            name = "PipeWire";
            mode = "create";
          };
        };
      };
    };

    services.pipewire.configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire-pulse.conf.d/50-snapserver-fifo.conf" ''
        pulse.cmd = [{ 
          cmd = "load-module"
          args = "module-pipe-sink file=/run/snapserver/fifo sink_name=Snapcast format=s16le rate=48000"
        }]
      '')
    ];


    # the below functions are useful if you want to restrict who can play via the fifo
    # however the fifo created by snapcast defaults to all writable, so you'd have to limit the permissions of that
    # before being able to use this

    # create pipe for pipewire sink playback
    # custom.nixos.behavior.tmpfiles."snapserver-fifo" = mkIf cfg.sink {
    #   type = "p";
    #   path = "/run/snapserver-pipewire/adminfifo";
    #   mode = "1660";
    #   user = "root";
    #   group = "wheel";
    #   age = "-";
    #   argument = "-";
    # };

    # connect pipe to snapserver's pipe
    # systemd.services.snapserver-adminfifo = mkIf cfg.sink {
    #   after = [ "snapserver.service" ];
    #   wantedBy = [ "multi-user.target" ];
    #   description = "fifo to snapserver fifo";
    #   serviceConfig = {
    #     ExecStart = pkgs.writeShellScript "snapserver-adminfifo" ''
    #       ${pkgs.coreutils}/bin/cat /run/snapserver-pipewire/adminfifo > /run/snapserver/fifo
    #     '';
    #     Restart = "always";
    #   };
    # };

    # in addition, configPackages should be moved to a setHMOpt to set ~/.config/pipewire/...

  } // (setHMOpt admins {
    custom.home.programs.sway.shortcuts.admin.firewall = {
      snapweb = pkgs.sway-kitty-popup-admin "shortcuts-admin-firewall-snapweb" ''
        sudo nixos-firewall-tool open tcp 1780
      '';
    };
  }));
}
