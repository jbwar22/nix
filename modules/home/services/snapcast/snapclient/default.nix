{ config, lib, pkgs, ... }:

with lib; with namespace config { home.services.snapcast.snapclient = ns; }; {
  options = opt {
    enable = mkEnableOption "snapclient";
  };

  config = mkIf cfg.enable {
    systemd.user.enable = mkDefault true;
    systemd.user.services.snapclient = {
      Unit = {
        Description = "snapclient to localhost";
        Requires = [ "pipewire.service" ];
        After = "pipewire.target";
      };
      Service = {
        ExecStart = "${pkgs.snapcast}/bin/snapclient -h 127.0.0.1";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
