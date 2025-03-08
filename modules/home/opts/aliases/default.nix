{ config, lib, ... }:

with lib; with namespace config { home.opts.aliases = ns; }; {
  options = opt (mkOption {
    type = with types; attrsOf str;
    description = "aliases";
  });
}
