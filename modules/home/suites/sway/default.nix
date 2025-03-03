{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.suites.sway = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "sway wm & related programs";
  };

  config = lib.mkIf cfg.enable {
    custom.home = {
      programs = {

        sway.enable = true;
        
        dunst.enable = true;
        swaylock.enable = true;
        tofi.enable = true;
        waybar.enable = true;

      };
    };
  };
}
