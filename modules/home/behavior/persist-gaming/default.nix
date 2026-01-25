{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home.behavior.impermanence.paths = [
    ".steam"
    ".config/unity3d"
    ".local/share/Steam"
  ];
}
