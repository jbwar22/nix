{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { home.programs.noconfig.gui = ns; }) cfg opt;
in
{
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
  in lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      chromium
      element-desktop
      feh
      gimp
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
    };
  };
}
