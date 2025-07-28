{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home.behavior.impermanence.dirs = [
    "work"
    ".aws"
  ];
}
