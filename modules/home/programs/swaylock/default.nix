{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { home.programs.swaylock = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "swaylock";
  };

  config = lib.mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock;
      settings = {
        show-keyboard-layout = true;
        show-failed-attempts = true;
        image = "${config.custom.home.opts.wallpaper.path}";
        inside-color = "660000";
        inside-clear-color = "666666";
        inside-caps-lock-color = "660000";
        inside-ver-color = "666666";
        inside-wrong-color = "444444";
        key-hl-color = "CC0000";
        line-color = "000000";
        line-caps-lock-color = "000000";
        line-ver-color = "000000";
        line-wrong-color = "000000";
        ring-color = "440000";
        ring-ver-color = "444444";
        ring-wrong-color = "222222";
        separator-color = "000000";
        text-color = "FFFFFF";
        text-clear-color = "FFFFFF";
        text-caps-lock-color = "FFFFFF";
        text-ver-color = "FFFFFF";
        text-wrong-color = "FFFFFF";
      };
    };
  };
}
