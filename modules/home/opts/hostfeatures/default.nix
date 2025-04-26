{ config, lib, osConfig, ... }:

with lib; with ns config ./.; {
  options = opt {
    userIsAdmin = mkDisableOption "current user is admin on host";
    usesNixosFirewall = mkDisableOption "uses nixos firewall";
    runningSnapweb = mkDisableOption "running snapweb";
    hasCpupower = mkDisableOption "has cpupower package";
    hasSerialSupport = mkDisableOption "current user has dialout group";
    hasLibvirtd = mkDisableOption "has cpupower package";
    hasOvmf = mkDisableOption "has cpupower package";
  };

  config = if (osConfig != false) then (opt {
    userIsAdmin = true;
    usesNixosFirewall = osConfig.networking.firewall.enable;
    runningSnapweb = osConfig.custom.nixos.programs.snapserver.enable;
    hasCpupower = osConfig.custom.nixos.programs.cpupower.enable;
    hasSerialSupport = hasGroup config osConfig "dialout";
    hasLibvirtd = osConfig.virtualisation.libvirtd.enable;
    hasOvmf = osConfig.virtualisation.libvirtd.qemu.ovmf.enable;
  }) else {};
}
