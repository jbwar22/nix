{ clib, ... }:

let
  inherit (clib)
  enums;
in {
  config = {
    custom.common = {
      opt.hardware = {
        cpu = {
          vendor = enums.cpu-vendors.amd;
          threads = 12;
        };
        memory.size = 32;
        gpu.vendor = enums.gpu-vendors.nvidia;
      };
    };
  };
}
