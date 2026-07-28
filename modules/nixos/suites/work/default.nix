{ ns, ... }:

ns.enable {
  custom.nixos.behavior = {
    apparmor.enable = true;
  };
}
