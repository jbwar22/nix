{ config, lib, ... }:

with lib; with ns config ./.; {
  options = with types; opt {
    batteries = mkOption {
      description = "definition for each battery";
      type = attrsOf (submodule {
        options = {
          min = mkOption {
            type = int;
            description = "charge value at which to start charging";
          };
          max = mkOption {
            type = int;
            description = "charge value at which to stop charging";
          };
        };
      });
      default = {};
    };
    cpu.threads = mkOption {
      type = int;
      description = "number of cpu threads";
    };
    memory.size = mkOption {
      type = int;
      description = "size of memory in gb";
    };
    gpu = mkOption {
      description = "GPU vendor";
      type = types.enum (attrValues enums.gpu-vendors);
    };
    hasMicToggle = mkEnableOption "has software mic toggle button";
    interface.wifi = mkStrOption "default wifi interface";
    interface.ethernet = mkStrOption "default wifi interface";
  };
}
