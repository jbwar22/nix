{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.suite.gaming = ns; }) cfg opt;
in
{
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
