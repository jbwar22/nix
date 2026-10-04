{ lib, pkgs, ns, ... }:

let
  inherit (lib)
  attrValues
  mkDefault;
in ns.enable {
  services.flatpak.enable = true;
  # TODO TMP steam testing stuff, move or remove later
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };
  # TODO this is identical to home-manager config! fix
  xdg.portal = mkDefault {
    enable = true;
    extraPortals = attrValues {
      inherit (pkgs)
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr;
    };
    config = let
      portalcfg = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
    in {
      sway = portalcfg;
      common = portalcfg;
    };
  };

  custom.nixos.behavior.impermanence.paths = [ "/var/lib/flatpak" ];
}
