{ lib, ns, ... }:

{
  options = ns.eopt {
    country = lib.mkOption {
      type = lib.types.str;
      description = "country code";
      default = "US";
    };
  };
  config = ns.ecfg {
    boot.extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="${ns.cfg.country}"
    '';
  };
}
