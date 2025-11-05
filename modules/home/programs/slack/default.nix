{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    (wrapAndAddFlags slack [
      "--ozone-platform=wayland"
      "--wayland-text-input-version=3"
    ])
  ];

  custom.home.behavior.impermanence.dirs = [ ".config/Slack" ];
}
