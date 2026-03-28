{ config, lib, ns, ... }:

with lib; ns.enable {
  services.blueman-applet.enable = true;
}
