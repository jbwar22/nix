{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    file = mkOption {
      type = with types; str;
      default = "";
      description = "filename (within wallpaper folder) of wallpaper";
    };
    path = mkOption {
      type = with types; path;
      description = "file path of wallpaper";
    };
  };

  config = mkIf (cfg.file != "") ( opt {
    path = ../../../../secrets/git-crypt/wallpaper/${cfg.file};
  } );
}
