{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.nixos = {
    behavior = {
      nvidia.enable = config.custom.common.opts.hardware.nvidia;
    };
  };
}
