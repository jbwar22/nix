{ ns, ... }:

ns.enable {
  custom.nixos.behavior = {
    apparmor.enable = true;
    pwquality.enable = true;
  };
}
