{ config, lib, pkgs, ns, ... }:

ns.enable {
  programs.ranger = {
    enable = true;
    settings = {
      preview_images = true;
      preview_images_method = lib.mkIf config.custom.home.programs.kitty.enable "kitty";
    };
    mappings = {
      "<C-d>" = "shell ${pkgs.dragon-drop}/bin/dragon-drop -a -x %p";
    };
  };
}
