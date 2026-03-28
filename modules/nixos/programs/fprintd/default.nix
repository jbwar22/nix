{ config, lib, ns, ... }:

with lib; ns.enable {
  services.fprintd.enable = true;

  custom.nixos.behavior.impermanence.paths = [ "/var/lib/fprint" ];
}
