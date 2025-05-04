{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    vim
  ];

  custom.home.behavior.impermanence.files = [
    ".vimrc" # define in nix?
    # ".viminfo"
  ];
}
