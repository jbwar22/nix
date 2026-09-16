{ lib, ns, ... }:

{
  options = ns.opt (lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    description = "aliases";
  });
}
