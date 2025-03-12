{ config, lib, ... }:

with lib; with ns config ./.; {
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
