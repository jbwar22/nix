{ lib, ns, ... }:

{
  options = with lib; ns.opt (mkOption {
    type = with types; attrsOf str;
    description = "aliases";
  });
}
