{ config, lib, pkgs, ... }:

with lib; with namespace config { home.programs.noconfig.gaming = ns; }; {
  options = opt {
    enable = mkEnableOption "additional programs for use for gaming";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wineWowPackages.staging
      # wineWowPackages.waylandFull
    ];
  };
}
