{ config, lib, ... }:

with lib; with namespace config { nixos.opts.secrets = ns; }; {
  options = with types; opt {
    timeZone = mkOption {
      description = "Timezone for the computer";
      type = str;
      default = "Etc/GMT";
    };
  };
}
