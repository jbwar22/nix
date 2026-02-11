{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  services.gnome-keyring.enable = true;

  custom.home.behavior.impermanence.paths = [
    ".local/share/keyrings"
  ];
}
