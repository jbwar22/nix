{ config, lib, ... }:

with lib; with ns config ./.; {
  options = with types; opt {
    timeZone = mkOption {
      description = "Timezone for the computer";
      type = str;
      default = "Etc/GMT";
    };
  };
}
