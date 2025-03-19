{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.blueman-applet.enable = true;
}
