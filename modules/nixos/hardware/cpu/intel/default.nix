{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.hardware.cpu.intel = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "hardware options for intel cpus";
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "kvm-intel" ];
    nixpkgs.hostPlatform = mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
  };
}
