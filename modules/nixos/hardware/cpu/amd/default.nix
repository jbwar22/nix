{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  boot.kernelModules = [ "kvm-amd" ];
  nixpkgs.hostPlatform = mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
