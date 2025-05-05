{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    slack
  ];

  custom.home.behavior.impermanence.dirs = [ ".config/Slack" ];
}
