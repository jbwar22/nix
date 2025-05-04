{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    signal-desktop
  ];

  home.persistence = persistUserDirs config [ ".config/Signal" ];
}
