{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    vim
  ];

  custom.home.behavior.impermanence.paths = [
    { path = ".vimrc"; file = true; } # define in nix?
    # ".viminfo"
  ];
}
