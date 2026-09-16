{ lib, ns, ... }:

{
  options = ns.opt (lib.mkOption {
    type = lib.types.listOf lib.types.package;
    description = "sessions the user expects to be avaiable at login";
    default = [];
  });
}
