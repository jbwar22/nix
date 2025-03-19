{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home = {
    programs = {
      noconfig.gaming.enable = true;
    };
  };
}
