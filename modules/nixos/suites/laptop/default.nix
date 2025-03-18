{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "suite of nixos modules for laptop hosts";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos = {
      programs = {
        cpupower.enable = true;
      };
    };
  };
}
