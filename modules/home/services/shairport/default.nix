{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "shairport-sync systemd service";
  };

  config = mkIf cfg.enable {
    systemd.user.enable = mkDefault true;
    systemd.user.services.shairport-sync = {
      Unit = {
        Description = "shairport-sync airplay server";
        Requires = [ "pipewire.service" ];
        After = "pipewire.target";
      };
      Service = {
        ExecStart = pkgs.writeShellScript "shairport-sync" ''
          ${pkgs.shairport-sync}/bin/shairport-sync -o pa
        '';
        # ${pkgs.shairport-sync}/bin/shairport-sync -o pa -a "${host}" --password="${secrets.conf.shairport-password}"
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
