{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    gimp3
    element-desktop
    feh
    prismlauncher
    qbittorrent
    qpwgraph
    spotify
    sqlitebrowser
    vlc
    zoom-us
  ];
}
