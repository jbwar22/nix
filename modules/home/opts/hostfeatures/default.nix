{ config, lib, osConfig, ... }:

with lib; with ns config ./.; {
  options = opt {
    userIsAdmin = mkDisableOption "current user is admin on host";
    usesNixosFirewall = mkDisableOption "uses nixos firewall";
    runningSnapweb = mkDisableOption "running snapweb";
    hasCpupower = mkDisableOption "has cpupower package";
    hasDialoutGroup = mkDisableOption "current user has dialout group";
    hasOvmf = mkDisableOption "has cpupower package";
  };

  config = if (osConfig != false) then (opt {
    userIsAdmin = true;
    usesNixosFirewall = osConfig.networking.firewall.enable;
    runningSnapweb = osConfig.custom.nixos.programs.snapserver.enable;
    hasCpupower = osConfig.custom.nixos.programs.cpupower.enable;
    hasDialoutGroup = hasGroup config osConfig "dialout";
    hasOvmf = osConfig.virtualisation.libvirtd.qemu.ovmf.enable;
  }) else {};
}
