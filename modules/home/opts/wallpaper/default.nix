{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt (mkOption {
    type = with types; path;
    description = "file path of wallpaper";
  });
}
