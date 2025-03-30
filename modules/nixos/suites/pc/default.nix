{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.nixos = {
    behavior = {
      bluetooth.enable = true;
      graphics.enable = true;
      ios-mount.enable = true;
      printing.enable = true;
      sound.enable = true;
    };

    programs = {
      noconfig.vpn.enable = true;
      arduino.enable = true;
      docker.enable = true;
      flatpak.enable = true;
      plymouth.enable = true;
      udiskie.enable = true;
    };
  };
}
