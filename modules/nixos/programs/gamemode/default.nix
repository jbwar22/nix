{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  programs.gamemode.enable = true;
}
