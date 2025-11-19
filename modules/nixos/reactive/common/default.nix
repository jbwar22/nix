{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.nixos = {
    behavior = {
      nvidia.enable = config.custom.common.opts.hardware.gpu.vendor == enums.gpu-vendors.nvidia;
    };
  };
}
