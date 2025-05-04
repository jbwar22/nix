{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  environment.persistence = persistSysDirs config [
    "/var/lib/blueman"
    "/var/lib/bluetooth"
  ];
}
