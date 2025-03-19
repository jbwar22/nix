{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home = {
    programs = {
      noconfig.work.enable = true;
    };
    services = {
      locker.enable = true;
    };
  };
}
