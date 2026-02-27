{ config, lib, ... }:

with lib; with ns config ./.; {
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
