{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    gimp3
    element-desktop
    feh
    prismlauncher
    qbittorrent
    qpwgraph
    (wrapWaylandElectron spotify)
    sqlitebrowser
    vlc
    zoom-us
    mullvad-browser
  ];
}
