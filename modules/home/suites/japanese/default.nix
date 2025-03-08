{ config, lib, ... }:

with lib; with namespace config { home.suites.japanese = ns; }; {
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
