{ config, lib, ... }:

with lib; with namespace config { nixos.behavior.appimage = ns; }; {
  options = opt {
    enable = mkEnableOption "options to better run appimages";
  };

  config = lib.mkIf cfg.enable {
    programs.appimage.binfmt = true;
  };
}
