{ config, lib, ns, ... }:

with lib; ns.enable {
  custom.nixos = {
    programs = {
      steam.enable = true;
      gamemode.enable = true;
    };
    behavior = {
      gamepad-support.enable = true;
    };
  };
}
