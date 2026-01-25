{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    wineWowPackages.stable
    winetricks
  ];

  custom.home.behavior.impermanence.dirs = [
    ".wine"
  ];
  custom.home.behavior.impermanence.dirsLocal = [
    ".cache/wine"
    ".cache/winetricks"
  ];
}
