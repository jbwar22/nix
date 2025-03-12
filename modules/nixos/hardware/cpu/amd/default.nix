{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "hardware options for amd cpus";
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "kvm-amd" ];
    nixpkgs.hostPlatform = mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
