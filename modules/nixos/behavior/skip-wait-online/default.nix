{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
}
