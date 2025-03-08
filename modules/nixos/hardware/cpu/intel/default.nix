{ config, lib, ... }:

with lib; with namespace config { nixos.hardware.cpu.intel = ns; }; {
  options = opt {
    enable = mkEnableOption "hardware options for intel cpus";
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "kvm-intel" ];
    nixpkgs.hostPlatform = mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
  };
}
