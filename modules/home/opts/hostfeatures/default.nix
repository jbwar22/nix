{ config, lib, osConfig, ... }:

with lib; with ns config ./.; {
  options = opt {
    userIsAdmin = mkDisableOption "current user is admin on host";
    usesNixosFirewall = mkDisableOption "uses nixos firewall";
    runningSnapweb = mkDisableOption "running snapweb";
    hasCpupower = mkDisableOption "has cpupower package";
    hasSerialSupport = mkDisableOption "current user has dialout group";
    hasLibvirtd = mkDisableOption "has cpupower package";
    hasTailscale = mkDisableOption "has tailscale";
    hasFuseAllowOther = mkDisableOption "has userAllowOther for fuse";
    hasUdisks2 = mkDisableOption "has udisks2";
    hasWireplumber = mkDisableOption "has wireplumber";
    hasTmpfsRoot = mkDisableOption "root is tmpfs";
  };

  config = if (osConfig != false) then (opt {
    userIsAdmin = true;
    usesNixosFirewall = osConfig.networking.firewall.enable;
    runningSnapweb = osConfig.custom.nixos.programs.snapserver.enable;
    hasCpupower = osConfig.custom.nixos.programs.cpupower.enable;
    hasSerialSupport = hasGroup config osConfig "dialout";
    hasLibvirtd = osConfig.virtualisation.libvirtd.enable;
    hasTailscale = osConfig.services.tailscale.enable;
    hasFuseAllowOther = osConfig.programs.fuse.userAllowOther;
    hasUdisks2 = osConfig.services.udisks2.enable;
    hasWireplumber = osConfig.services.pipewire.wireplumber.enable;
    hasTmpfsRoot = osConfig.fileSystems."/".fsType == "tmpfs";
  }) else {};
}
