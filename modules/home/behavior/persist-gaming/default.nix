{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home.behavior.impermanence.dirs = [
    ".steam"
    ".config/unity3d"
    ".local/share/Steam"
  ];
}
