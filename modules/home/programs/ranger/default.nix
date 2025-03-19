{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  programs.ranger = {
    enable = true;
    settings = {
      preview_images = true;
      preview_images_method = mkIf config.custom.home.programs.kitty.enable "kitty";
    };
  };
}
