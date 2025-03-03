{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.hardware.cpu.amd = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "hardware options for amd cpus";
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "kvm-amd" ];
    nixpkgs.hostPlatform = mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
