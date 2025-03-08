{ config, lib, ... }:

with lib; with namespace config { nixos.reactive.common = ns; }; {
  options = opt {
    enable = mkEnableOption "options reactive based on common options for all hosts";
  };

  config = mkIf cfg.enable {
    custom.nixos = {
      behavior = {
        nvidia.enable = config.custom.common.opts.hardware.nvidia;
      };
    };
  };
}
