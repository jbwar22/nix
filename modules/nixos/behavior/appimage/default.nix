{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.behavior.appimage = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "options to better run appimages";
  };

  config = lib.mkIf cfg.enable {
    programs.appimage.binfmt = true;
  };
}
