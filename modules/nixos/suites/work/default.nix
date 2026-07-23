{ ns, ... }:

ns.enable {
  custom.nixos.programs = {
    clamav.enable = true;
  };
}
