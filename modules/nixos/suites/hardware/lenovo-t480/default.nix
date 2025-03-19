{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.nixos = {
    hardware.system.lenovo-t480.enable = true;

    behavior = {
      t480-rebinds.enable = true;
      t480-power.enable = true;
    };
  };
}
