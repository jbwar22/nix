{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { nixos.behavior.latencykernel = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "optimize kernel for latency";
  };
  config = lib.mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_zen;
  };
}
