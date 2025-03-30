{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
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
