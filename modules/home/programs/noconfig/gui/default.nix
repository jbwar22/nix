{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  houdoku = (pkgs.appimageTools.wrapType2 {
    name = "houdoku";
    src = pkgs.fetchurl {
      url = "https://github.com/xgi/houdoku/releases/download/v2.16.0/Houdoku-2.16.0.AppImage";
      hash = "sha256-P9f8t5K6c9hF/qe0Fqv5pAgB3rjya9FswV6sPF1ykOg=";
    };
  });
  gimp_3 = (pkgs.appimageTools.wrapType2 {
    name = "gimp_3";
    src = pkgs.fetchurl {
      url = "https://download.gimp.org/gimp/v3.0/linux/GIMP-3.0.0-x86_64.AppImage";
      hash = "sha256-9S6+SYirgYYVVJ7N/7Jx5uIOnIQSkDXZOqpPtB+lqWo=";
    };
  });
in {
  home.packages = with pkgs; [
    chromium
    element-desktop
    feh
    gimp_3
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
      name = "Gimp 3";
      exec = "${gimp_3}/bin/gimp_3";
    };
  };
})
