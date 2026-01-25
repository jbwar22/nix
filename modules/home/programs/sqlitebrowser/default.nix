{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    sqlitebrowser
  ];

  custom.home.behavior.impermanence.paths = [ ".config/sqlitebrowser" ];
}
