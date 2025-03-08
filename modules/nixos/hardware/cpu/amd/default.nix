{ config, lib, ... }:

with lib; with namespace config { nixos.hardware.cpu.amd = ns; }; {
  options = opt {
    enable = mkEnableOption "hardware options for amd cpus";
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "kvm-amd" ];
    nixpkgs.hostPlatform = mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
