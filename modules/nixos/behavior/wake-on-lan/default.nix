{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  networking.interfaces.${config.custom.common.opts.hardware.interface.ethernet}.wakeOnLan = {
    enable = true;
  };
}
