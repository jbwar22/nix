{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.xserver.desktopManager.runXdgAutostartIfNone = mkDefault true;
}
