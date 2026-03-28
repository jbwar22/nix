{ config, lib, ns, ... }:

with lib; ns.enable {
  boot.kernelModules = [ "kvm-intel" ];
  nixpkgs.hostPlatform = mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
}
