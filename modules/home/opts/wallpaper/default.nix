{ lib, ns, ... }:

let
  inherit (lib.types)
  oneOf
  path
  str;
in {
  options = ns.opt {
    dir = lib.mkOption {
      type = oneOf [str path];
      description = "dir for wallpaper symlinks";
      default = ns.cfg.base;
    };
  };
}
