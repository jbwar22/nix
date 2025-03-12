{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "hardware options for intel cpus";
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "kvm-intel" ];
    nixpkgs.hostPlatform = mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
  };
}
