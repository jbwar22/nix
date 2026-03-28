{ config, lib, ns, ... }:

with lib; ns.enable {
  custom.nixos = {
    hardware.system.framework-13.enable = true;
    behavior.regdomain.enable = true;
    programs.fprintd.enable = true;
  };
}
