{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home = {
    programs = {

      sway.enable = true;
      
      dunst.enable = true;
      swaylock.enable = true;
      swayidle.enable = true;
      tofi.enable = true;
      waybar.enable = true;

    };
  };
}
