{ config, lib, ns, ... }:

with lib; ns.enable {
  custom.nixos = {
    programs = {
      cpupower.enable = true;
    };
  };
}
