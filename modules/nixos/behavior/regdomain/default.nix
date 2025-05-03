{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "modprobe config for regulatory domain";
    country = mkOption {
      type = with types; str;
      description = "country code";
      default = "US";
    };
  };
  config = mkIf cfg.enable {
    boot.extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="${cfg.country}"
    '';
  };
}
