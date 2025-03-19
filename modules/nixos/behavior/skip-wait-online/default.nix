{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  # enable if having issues with network manager wait online
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
}
