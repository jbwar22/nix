{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home = {
    programs = {
      noconfig.laptop.enable = true;
    };
  };
}
