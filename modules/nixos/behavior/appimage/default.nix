{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "options to better run appimages";
  };

  config = lib.mkIf cfg.enable {
    programs.appimage.binfmt = true;
  };
}
