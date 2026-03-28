{ config, lib, ns, ... }:

with lib; ns.enable {
  custom.nixos = {
    behavior = {
      nvidia.enable = config.custom.common.opts.hardware.gpu.vendor == enums.gpu-vendors.nvidia;
    };
  };
}
