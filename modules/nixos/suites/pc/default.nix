{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.nixos = {
    behavior = {
      bluetooth.enable = true;
      graphics.enable = true;
      ios-mount.enable = true;
      powerbutton-lock-power.enable = true;
      printing.enable = true;
      serial-support.enable = true;
      sound.enable = true;
    };

    programs = {
      noconfig.vpn.enable = true;
      docker.enable = true;
      flatpak.enable = true;
      plymouth.enable = true;
      udisks2.enable = true;
    };
  };
}
