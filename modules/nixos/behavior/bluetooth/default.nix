{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  custom.nixos.behavior.impermanence.dirs = [
    "/var/lib/blueman"
    "/var/lib/bluetooth"
  ];
}
