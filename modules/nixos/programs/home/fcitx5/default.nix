{ lib, ns, ... }:

ns.enable {
  services.xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;
}
