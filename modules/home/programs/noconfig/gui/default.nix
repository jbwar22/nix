{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "gui programs with no additional config";
  };

  config = let
    houdoku = (pkgs.appimageTools.wrapType2 {
      name = "houdoku";
      src = pkgs.fetchurl {
        url = "https://github.com/xgi/houdoku/releases/download/v2.16.0/Houdoku-2.16.0.AppImage";
        hash = "sha256-P9f8t5K6c9hF/qe0Fqv5pAgB3rjya9FswV6sPF1ykOg=";
      };
    });
    gimp-beta = (pkgs.appimageTools.wrapType2 {
      name = "gimp-beta";
      src = pkgs.fetchurl {
        url = "https://download.gimp.org/gimp/v3.0/linux/GIMP-3.0.0-RC3-x86_64.AppImage";
        hash = "sha256-OD9iXtN6LW0uXCK6rS8+O2xQ081RnrbgkGmQN4O8rHo=";
      };
    });
  in lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      chromium
      element-desktop
      feh
      gimp-beta
      houdoku
      prismlauncher
      qbittorrent
      qpwgraph
      signal-desktop
      spotify
      sqlitebrowser
      zoom-us
    ];

    xdg.desktopEntries = {
      houdoku = {
        name = "Houdoku";
        exec = "${houdoku}/bin/houdoku";
      };
      gimp-beta = {
        name = "Gimp Beta";
        exec = "${gimp-beta}/bin/gimp-beta";
      };
    };
  };
}
