{ config, lib, ...}:

with lib; mkNsEnableModule config ./. {
  services.upower.enable = true;
}
