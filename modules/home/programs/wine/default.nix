{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    wineWowPackages.stable
    winetricks
  ];

  custom.home.behavior.impermanence.dirs = [
    ".wine"
    { path = ".cache/wine"; local = true; }
    { path = ".cache/winetricks"; local = true; }
  ];
}
