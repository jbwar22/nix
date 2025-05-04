{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    vim
  ];

  home.persistence = persistUserFiles config [
    ".vimrc" # define in nix?
    # ".viminfo"
  ];
}
