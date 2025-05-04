{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    git
    git-crypt
  ];

  home.persistence = persistUserFiles config [ ".gitconfig" ];
}
