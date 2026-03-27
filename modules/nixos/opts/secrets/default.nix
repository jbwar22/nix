{ lib, ns, ... }:

{
  options = ns.opt {
    timeZone = lib.mkOption {
      description = "Timezone for the computer";
      type = with lib.types; nullOr str;
      default = null;
    };
  };
}

