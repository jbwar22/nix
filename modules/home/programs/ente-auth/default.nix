{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    ente-auth
  ];

  custom.home.behavior.impermanence.paths = [
    ".local/share/io.ente.auth"
  ];
}
