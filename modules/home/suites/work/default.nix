{ config, lib, ... }:

with lib; with namespace config { home.suites.work = ns; }; {
  options = opt {
    enable = mkEnableOption "all extra options for use as a work computer";
  };

  config = lib.mkIf cfg.enable {
    custom.home = {
      programs = {
        noconfig.work.enable = true;
      };
      services = {
        locker.enable = true;
      };
    };
  };
}
