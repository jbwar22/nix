{ lib, ns, ... }:

{
  options = ns.opt {
    timeZone = lib.mkOption {
      description = "Timezone for the computer";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };
}

