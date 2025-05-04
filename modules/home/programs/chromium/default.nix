{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    chromium
  ];

  home.persistence = persistUserDirs config [ ".config/chromium" ];
}
