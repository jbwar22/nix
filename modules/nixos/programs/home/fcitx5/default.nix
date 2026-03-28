{ config, lib, ns, ... }:

with lib; ns.enable {
  services.xserver.desktopManager.runXdgAutostartIfNone = mkDefault true;
}
