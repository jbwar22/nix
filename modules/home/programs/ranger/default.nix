{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  programs.ranger = {
    enable = true;
    settings = {
      preview_images = true;
      preview_images_method = mkIf config.custom.home.programs.kitty.enable "kitty";
    };
    mappings = {
      "<C-d>" = "shell ${pkgs.dragon-drop}/bin/dragon-drop -a -x %p";
    };
  };
}
