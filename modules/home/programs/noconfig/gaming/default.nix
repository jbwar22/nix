{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
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
