{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    wineWowPackages.staging
    winetricks
  ];

  custom.home.behavior.impermanence.dirs = [
    ".wine"
    ".cache/wine"
    ".cache/winetricks"
  ];
}
