{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    git
    git-crypt
  ];

  custom.home.behavior.impermanence.files = [ ".gitconfig" ];
}
