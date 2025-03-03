{ pkgs, config, lib, ... }:

with lib;
let
  inherit (namespace config { home.programs.fcitx5 = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "fcitx5 (japanese ime)";
    basic = mkEnableOption "don't set configuration";
  };

  config = mkIf cfg.enable {

    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = [
        pkgs.fcitx5-mozc
      ];
    };

    xdg.configFile = mkIf (!cfg.basic) {
      "fcitx5/config".source = ./fcitx5/config;
      "fcitx5/profile".source = ./fcitx5/profile;
      "fcitx5/conf/mozc.conf".source = ./fcitx5/conf/mozc.conf;
      "mozc/config1.db".source = ./mozc/config1.db;
      # "mozc/user_dictionary.db".source = ./TODO secret
    };

  };
}
