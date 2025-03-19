{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.vnstat.enable = true;
}
