{ lib, ns, ... }:

with lib; with ns; {
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
