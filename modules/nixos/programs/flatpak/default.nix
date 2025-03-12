{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "flatpak";
  };

  config = lib.mkIf cfg.enable {

    services.flatpak.enable = true;
    xdg.portal = mkDefault {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      config.common.default = "gtk";
    };
  };
}
