{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home = {
    programs = {
      noconfig.work.enable = true;
      slack.enable = true;
    };
    services = {
      locker.enable = true;
    };
    behavior = {
      persist-work.enable = true;
    };
  };
}
