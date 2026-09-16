{ lib, pkgs, ns, ... }:

ns.enable {
  services.flatpak.enable = true;
  xdg.portal = lib.mkDefault {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };

  custom.nixos.behavior.impermanence.paths = [ "/var/lib/flatpak" ];
}
