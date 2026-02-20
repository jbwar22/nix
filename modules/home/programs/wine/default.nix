{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    wineWowPackages.stable
    winetricks
  ];

  custom.home.behavior.impermanence.paths = [
    ".wine"
    { path = ".cache/wine"; origin = "local"; }
    { path = ".cache/winetricks"; origin = "local"; }
  ];
}
