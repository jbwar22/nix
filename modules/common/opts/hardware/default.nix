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
    nvidia = mkEnableOption "does the system use an nvidia gpu";
    hasMicToggle = mkEnableOption "has software mic toggle button";
  };
}
