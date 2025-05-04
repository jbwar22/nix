{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    sqlitebrowser
  ];

  home.persistence = persistUserDirs config [ ".config/sqlitebrowser" ];
}
