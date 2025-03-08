{ config, lib, ... }:

with lib; with namespace config { home.suites.sway = ns; }; {
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
