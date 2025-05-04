{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    rpcs3
  ];

  custom.home.behavior.impermanence.dirs = [ ".cache/rpcs3" ];
}
