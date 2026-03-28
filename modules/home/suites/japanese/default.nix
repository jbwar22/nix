{ config, lib, ns, ... }:

with lib; ns.enable {
  custom.home = {
    programs = {
      fcitx5.enable = true;
    };
  };
}
