{ lib, pkgs, ns, ... }:

with lib; ns.enable {
  services.flatpak.enable = true;
  xdg.portal = mkDefault {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };
}
