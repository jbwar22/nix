{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.nixos = {
    hardware.system.gigabyte-b550i.enable = true;
  };
}
