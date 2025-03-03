{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.reactive.common = ns; }) cfg opt;
in
{
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
