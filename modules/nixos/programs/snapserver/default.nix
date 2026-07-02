{ config, lib, clib, pkgs, ns, ... }:

with lib; with clib; with ns; let
  configfile = ageOrNull config "snapserver-shairport-config";
in {
  options = opt {
    enable = mkEnableOption "snapserver to control multi room audio";
    sink = {
      enable = clib.mkDisableOption "custom pulse sync";
    };
    tcp-server = {
      enable = clib.mkDisableOption "tcp server input";
      port = mkOption {
        description = "port for tcp server input to listen on";
        type = types.number;
        default = 4953;
      };
    };
    airplay = {
      port = mkOption {
        description = "port for shairport to listen on";
        type = with types; number;
        default = 5000;
      };
    };
  };

  config = mkIf cfg.enable {
    custom.nixos.behavior.shairport-support = {
      enable = mkDefault true;
      ports = [ cfg.airplay.port ];
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
    networking.firewall.allowedTCPPorts = mkMerge [
      [
        config.services.snapserver.settings.tcp-streaming.port
      ]
      (mkIf cfg.tcp-server.enable [
        cfg.tcp-server.port
      ])
    ];

    services.snapserver = {
      enable = true;
      openFirewall = false;
      settings = {
        tcp = {
          enabled = true;
        };
        http = {
          enabled = true;
          docRoot = "${pkgs.snapweb}";
        };
        stream.source = let
          getQuery = x: pipe x [
            attrsToList
            (map (y: "${y.name}=${y.value}"))
            (concatStringsSep "&")
          ];
          toURI = (x: "${x.type}://${x.location}?${getQuery x.query}");
        in mkMerge [
          [(toURI {
            type = "airplay";
            location = "${pkgs.shairport-sync}/bin/shairport-sync";
            query = {
              name = "AirPlay";
              devicename = "${capitalizeDashedString config.custom.common.opts.host.hostname} Snapcast";
              params = let
                params = singleton "--port=${toString cfg.airplay.port}"
                  ++ optional (configfile != null) "--configfile=\${CREDENTIALS_DIRECTORY}/configfile";
              in concatStringsSep " " params;
            };
          })]
          [(mkIf cfg.tcp-server.enable (toURI {
            type = "tcp";
            location = "0.0.0.0:${toString cfg.tcp-server.port}";
            query = {
              name = "TCP Stream";
            };
          }))]
          [(mkIf cfg.sink.enable (toURI {
            type = "pipe";
            location = "/run/snapserver/fifo";
            query = {
              name = "PipeWire";
              mode = "create";
            };
          }))]
        ];
      };
    };

    services.pipewire.configPackages = mkIf cfg.sink.enable [
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
  };
}
