{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home = {
    programs = {

      sway.enable = true;
      
      dunst.enable = true;
      swaylock.enable = true;
      tofi.enable = true;
      waybar.enable = true;

    };
  };
}
