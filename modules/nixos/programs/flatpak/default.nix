{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  services.flatpak.enable = true;
  xdg.portal = mkDefault {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };
}
