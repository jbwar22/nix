{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home = {
    programs = {
      arduino.enable = true;
    };
  };
}
