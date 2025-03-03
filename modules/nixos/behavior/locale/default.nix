{ config, lib, ...}:

with lib;
let
  inherit (namespace config { nixos.behavior.locale = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "Whether to set the locale to default (english)";
  };
  config = lib.mkIf cfg.enable {
    i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "ja_JP.UTF-8/UTF-8"
      ];
    };
  };
}
