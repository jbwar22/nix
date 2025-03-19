{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.udiskie.enable = true;
}
