{ ns, pkgs, ... }:

ns.enable {
  services.flatpak.enable = true;
  xdg.portal = { # flatpak module complains if not set
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [ "gtk" ];
  };
  custom.nixos.behavior.impermanence.paths = [ "/var/lib/flatpak" ];
}
