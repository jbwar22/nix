{ lib, ns, ... }:

with lib; with ns; {
  options = eopt {
    country = mkOption {
      type = with types; str;
      description = "country code";
      default = "US";
    };
  };
  config = ecfg {
    boot.extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="${cfg.country}"
    '';
  };
}
