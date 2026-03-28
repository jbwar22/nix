{ config, lib, ns, ... }:

with lib; with ns; {
  options = opt {
    base = mkOption {
      type = with types; oneOf [str path];
      description = "file path of wallpaper";
    };
    lock-screen = mkOption {
      type = with types; oneOf [str path];
      description = "file path of wallpaper";
      default = cfg.base;
    };
  };
}
