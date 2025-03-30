{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    wineWowPackages.staging
    # wineWowPackages.waylandFull
    rpcs3
  ];
}
