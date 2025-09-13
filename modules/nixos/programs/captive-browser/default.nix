{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  programs.captive-browser = {
    enable = true;
    interface = config.custom.common.opts.hardware.interface.wifi;
  };
}
