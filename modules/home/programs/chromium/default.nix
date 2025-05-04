{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    chromium
  ];

  custom.home.behavior.impermanence.dirs = [ ".config/chromium" ];
}
