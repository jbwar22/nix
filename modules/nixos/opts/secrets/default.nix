{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    timeZone = mkOption {
      description = "Timezone for the computer";
      type = with types; nullOr str;
      default = null;
    };
  };
}
