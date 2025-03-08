{ config, lib, pkgs, ... }:

with lib; with namespace config { home.programs.librewolf = ns; }; {
  options = opt {
    enable = mkEnableOption "librewolf";
  };

  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf;
      settings = {
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        # "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };

    xdg.desktopEntries = let
      lwdesktop = {
        type = "Application";
        genericName = "Web Browser";
        comment = "Browse the World Wide Web";
        mimeType = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "application/x-xpinstall"
          "application/pdf"
        ];
        settings = {
          Keywords = "Internet;WWW;Browser;Web;Explorer";
          Terminal = "false";
        };
      };
    in {
      librewolfp1 = lwdesktop // {
        name = "LibreWolf (Personal)";
        exec = "${pkgs.librewolf}/bin/librewolf -P Personal %u";
        noDisplay = true;
      };
      librewolf = lwdesktop // {
        name = "LibreWolf (Profile Manager)";
        exec = "${pkgs.librewolf}/bin/librewolf --ProfileManager %u";
        noDisplay = false;
      };
    };
  };
}
