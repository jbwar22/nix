{ config, lib, ...}:

with lib; with ns config ./.; {
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
