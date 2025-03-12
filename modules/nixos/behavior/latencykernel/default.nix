{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "optimize kernel for latency";
  };
  config = lib.mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_zen;
  };
}
