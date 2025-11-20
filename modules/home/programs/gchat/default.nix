{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  gchat = (wrapAndAddFlags pkgs.google-chat-linux [
    "--ozone-platform=wayland"
    "--wayland-text-input-version=3"
  ]);
in {
  home.packages = [
    gchat
  ];

  custom.home.behavior.impermanence.dirs = [ ".config/google-chat-linux" ];
})
