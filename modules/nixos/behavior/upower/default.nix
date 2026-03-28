{ config, lib, ns, ...}:

with lib; ns.enable {
  services.upower.enable = true;
}
