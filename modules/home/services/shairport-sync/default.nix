{ config, lib, pkgs, host, ... }:

with lib; with namespace config { home.services.shairport-sync = ns; }; {
  options = opt {
    enable = mkEnableOption "sink-tcp";
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
        # ExecStart = pkgs.writeShellScript "shairport-sync" ''
        #   ${pkgs.shairport-sync}/bin/shairport-sync -o pa -a "${host}" --password="${secrets.conf.shairport-password}"
        # '';
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
