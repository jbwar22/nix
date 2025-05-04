{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  houdoku = (pkgs.appimageTools.wrapType2 {
    name = "houdoku";
    src = pkgs.fetchurl {
      url = "https://github.com/xgi/houdoku/releases/download/v2.16.0/Houdoku-2.16.0.AppImage";
      hash = "sha256-P9f8t5K6c9hF/qe0Fqv5pAgB3rjya9FswV6sPF1ykOg=";
    };
  });
in {
  home.packages = [
    houdoku
  ];

  xdg.desktopEntries = {
    houdoku = {
      name = "Houdoku";
      exec = "${houdoku}/bin/houdoku";
    };
  };

  custom.home.behavior.impermanence.dirs = [ ".config/Houdoku" ];
})
