{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.opts.aliases = ns; }) cfg opt;
in
{
  options = opt (mkOption {
    type = with types; attrsOf str;
    description = "aliases";
  });
}
