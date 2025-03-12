{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "blueman";
  };

  config = mkIf cfg.enable {
    services.blueman-applet.enable = true;
  };
}
