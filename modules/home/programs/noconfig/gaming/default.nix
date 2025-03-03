{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { home.programs.noconfig.gaming = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "additional programs for use for gaming";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wineWowPackages.waylandFull
    ];
  };
}
