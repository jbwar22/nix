{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "shairport-sync systemd service";
    port = mkOption {
      description = "port for shairport to listen on";
      type = with types; number;
      default = 5000;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.enable = mkDefault true;
    systemd.user.services.shairport-sync = {
      Unit = {
        Description = "shairport-sync airplay server";
        Requires = [ "pipewire.service" "agenix.service" ];
        After = "pipewire.target";
      };
      Service = {
        ExecStart = let
          password-file = ageOrNull config "shairport-password";
          password-arg = if password-file == null then "" else "--password=\"$(${pkgs.coreutils}/bin/cat ${password-file})\"";
        in pkgs.writeShellScript "shairport-sync" ''
          ${pkgs.shairport-sync}/bin/shairport-sync -o pa -p ${toString cfg.port} \
          -a "${capitalizeDashedString config.custom.common.opts.host.hostname}" ${password-arg}
        '';
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
