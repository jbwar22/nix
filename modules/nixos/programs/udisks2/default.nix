{ lib, ns, ... }:

with lib; ns.enable {
  services.xserver.desktopManager.runXdgAutostartIfNone = mkDefault true;
  services.udisks2.enable = true;
}
