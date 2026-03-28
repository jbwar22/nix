{ config, lib, ns, ... }:

with lib; ns.enable {
  boot.kernelModules = [ "kvm-amd" ];
  nixpkgs.hostPlatform = mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
