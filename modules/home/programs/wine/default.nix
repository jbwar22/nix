{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    wineWowPackages.staging
    winetricks
  ];

  home.persistence = persistUserDirs config [
    ".wine"
    ".cache/wine"
    ".cache/winetricks"
  ];
}
