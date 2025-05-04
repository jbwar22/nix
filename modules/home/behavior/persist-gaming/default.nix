{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  home.persistence = persistUserDirs config [
    ".steam"
    ".config/unity3d"
    ".local/share/Steam"
  ];
}
