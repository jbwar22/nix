{ config, lib, ns, ... }:

with lib; ns.enable {
  custom.nixos = {
    hardware.system.gigabyte-b550i.enable = true;
  };
}
