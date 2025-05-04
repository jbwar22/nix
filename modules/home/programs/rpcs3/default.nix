{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    rpcs3
  ];

  home.persistence = persistUserDirs config [ ".cache/rpcs3" ];
}
