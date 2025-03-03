{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.opts.secrets = ns; }) opt;
in
{
  options = with types; opt {
    geoLoc = mkOption {
      description = "Geo Location for the computer";
      type = str;
      default = "0.000:0.000";
    };
  };
}
