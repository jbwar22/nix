{ config, lib, ns, ... }:

with lib; ns.enable {
  custom.home = {
    programs = {
      noconfig.work.enable = true;
      slack.enable = true;
      gchat.enable = true;
    };
    services = {
      locker.enable = true;
    };
    behavior = {
      work.enable = true;
    };
  };
}
