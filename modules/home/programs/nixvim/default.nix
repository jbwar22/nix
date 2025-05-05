{ config, lib, pkgs, outputs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = [
    outputs.packages.${pkgs.system}.nixvim
  ];

  custom.home.behavior.impermanence.dirs = [
    ".local/state/nvim" # includes swp
    # ".local/share/nvim"
    # ".cache/nvim"
  ];
}
