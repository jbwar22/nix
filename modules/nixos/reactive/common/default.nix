{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.nixos = {
    behavior = {
      nvidia.enable = config.custom.common.opts.hardware.gpu == enums.gpu-vendors.nvidia;
    };
  };
}
