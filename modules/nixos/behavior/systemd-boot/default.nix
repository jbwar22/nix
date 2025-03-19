{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
