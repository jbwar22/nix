{ config, lib, ... }:

with lib; with namespace config { home.programs.blueman = ns; }; {
  options = opt {
    enable = mkEnableOption "blueman";
  };

  config = mkIf cfg.enable {
    services.blueman-applet.enable = true;
  };
}
