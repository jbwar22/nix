{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home = {
    programs = {
      arduino.enable = true;
      keyring.enable = true;
      ente-auth.enable = true;
    };
  };
}
