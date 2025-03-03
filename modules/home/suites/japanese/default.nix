{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.suites.japanese = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "options if using japanese input";
  };

  config = lib.mkIf cfg.enable {
    custom.home = {
      programs = {
        fcitx5.enable = true;
      };
    };
  };
}
