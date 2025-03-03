{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.programs.ranger = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "ranger";
  };

  config = mkIf cfg.enable {
    programs.ranger = {
      enable = true;
      settings = {
        preview_images = true;
        preview_images_method = mkIf config.custom.home.programs.kitty.enable "kitty";
      };
    };
  };
}
