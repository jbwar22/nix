{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.programs.blueman = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "blueman";
  };

  config = mkIf cfg.enable {
    services.blueman-applet.enable = true;
  };
}
