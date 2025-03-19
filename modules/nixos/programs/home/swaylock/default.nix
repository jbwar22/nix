{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  security.pam.services.swaylock = {};
  security.polkit.enable = mkDefault true;
}
