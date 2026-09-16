{ config, lib, clib, pkgs, ns, ... }:

let
  inherit (ns)
  ecfg
  eopt
  cfg;
  inherit (lib)
  mkDefault
  mkOption
  types;
  inherit (clib)
  ageOrNull
  capitalizeDashedString;
in {
  options = eopt {
    port = mkOption {
      description = "port for shairport to listen on";
      type = types.number;
      default = 5000;
    };
  };

  config = ecfg {
    systemd.user.enable = mkDefault true;
    systemd.user.services.shairport-sync = {
      Unit = {
        Description = "shairport-sync airplay server";
        Requires = [ "pipewire.service" "agenix.service" ];
        After = "pipewire.target";
      };
      Service = {
        PrivateTmp = true;
        KillSignal = "SIGINT"; # hangs on SIGTERM
        ExecStart = let
          password-file = ageOrNull config "shairport-password";
        in pkgs.writeShellScript "shairport-sync" (if password-file == null then ''
          ${pkgs.shairport-sync}/bin/shairport-sync \
          -o pulseaudio \
          -p ${toString cfg.port} \
          -a "${capitalizeDashedString config.custom.common.opts.host.hostname}"
        '' else ''
          ${pkgs.gnused}/bin/sed 's/.*/general = { password = "&"; }/' ${password-file} > /tmp/sp.conf
          ${pkgs.shairport-sync}/bin/shairport-sync \
          -o pulseaudio \
          -p ${toString cfg.port} \
          -a "${capitalizeDashedString config.custom.common.opts.host.hostname}" \
          -c /tmp/sp.conf
        '');
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
