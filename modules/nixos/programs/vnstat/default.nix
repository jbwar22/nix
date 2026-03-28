{ ns, ... }:

ns.enable {
  services.vnstat.enable = true;

  custom.nixos.behavior.impermanence.paths = [ "/var/lib/vnstat" ];
}
