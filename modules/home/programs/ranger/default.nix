{ config, lib, ... }:

with lib; with namespace config { home.programs.ranger = ns; }; {
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
