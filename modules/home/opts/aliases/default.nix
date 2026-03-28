{ config, lib, ns, ... }:

with lib; {
  options = ns.opt (mkOption {
    type = with types; attrsOf str;
    description = "aliases";
  });
}
