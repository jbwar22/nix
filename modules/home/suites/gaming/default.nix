{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "all extra options for use as a gaming computer";
  };

  config = lib.mkIf cfg.enable {
    custom.home = {
      programs = {
        noconfig.gaming.enable = true;
      };
    };
  };
}
