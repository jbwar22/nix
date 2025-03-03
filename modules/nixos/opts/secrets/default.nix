{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.opts.secrets = ns; }) opt;
in
{
  options = with types; opt {
    timeZone = mkOption {
      description = "Timezone for the computer";
      type = str;
      default = "Etc/GMT";
    };
  };
}
