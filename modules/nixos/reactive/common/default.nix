{ config, clib, ns, ... }:

ns.enable {
  custom.nixos = {
    behavior = {
      nvidia.enable = config.custom.common.opts.hardware.gpu.vendor == clib.enums.gpu-vendors.nvidia;
    };
  };
}
