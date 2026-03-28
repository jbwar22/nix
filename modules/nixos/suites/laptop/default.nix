{ ns, ... }:

ns.enable {
  custom.nixos = {
    programs = {
      cpupower.enable = true;
    };
  };
}
