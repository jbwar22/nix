{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.xserver.desktopManager.runXdgAutostartIfNone = mkDefault true;
  services.udisks2.enable = true;
}
