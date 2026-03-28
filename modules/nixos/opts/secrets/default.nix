{ lib, ns, ... }:

with lib; {
  options = ns.opt {
    timeZone = mkOption {
      description = "Timezone for the computer";
      type = with types; nullOr str;
      default = null;
    };
  };
}

