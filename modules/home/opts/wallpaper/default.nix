{ lib, ns, ... }:

with lib; with ns; {
  options = opt {
    dir = mkOption {
      type = with types; oneOf [str path];
      description = "dir for wallpaper symlinks";
      default = cfg.base;
    };
  };
}
