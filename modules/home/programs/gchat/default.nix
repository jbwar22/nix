{ lib, pkgs, ns, ... }:

with lib; ns.enable (let
  gchat = (wrapAndAddFlags pkgs.google-chat-linux [
    "--ozone-platform=wayland"
    "--wayland-text-input-version=3"
  ]);
in {
  home.packages = [
    gchat
  ];

  custom.home.behavior.impermanence.paths = [ ".config/google-chat-linux" ];
})
