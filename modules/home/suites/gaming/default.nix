{ config, lib, ns, ... }:

with lib; ns.enable {
  custom.home = {
    behavior = {
      persist-gaming.enable = true;
    };
    programs = {
      noconfig.gaming.enable = true;
      dolphin.enable = true;
      rpcs3.enable = true;
      wine.enable = true;
    };
  };
}
