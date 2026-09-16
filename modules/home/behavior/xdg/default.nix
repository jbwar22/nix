{ config, lib, pkgs, ns, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (lib)
  attrValues
  generators
  mkOption
  types;
in {
  options = eopt {
    defaultBrowser = mkOption {
      description = "default browser desktop file";
      type = types.str;
      default = "librewolfprofile.desktop";
    };
  };

  config = ecfg {
    home.packages = attrValues {
      inherit (pkgs)
      xdg-utils;
    };

    xdg.userDirs = {
      enable = true;
      desktop = null;
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = null;
      pictures = "${config.home.homeDirectory}/pictures";
      publicShare = null;
      templates = null;
      videos = "${config.home.homeDirectory}/videos";
      createDirectories = false;
      setSessionVariables = true;
    };

    xdg.systemDirs = {
      data = [ "/etc/profiles/per-user/${config.home.username}/share" ];
    };

    xdg.portal = {
      enable = true;
      extraPortals = attrValues {
        inherit (pkgs)
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr;
      };
      xdgOpenUsePortal = true;
      config = {
        sway.default   = [ "wlr" ];
        common.default = [ "wlr" ];
      };
    };


    xdg.configFile."xdg-desktop-portal-wlr/config".text = generators.toINI {} {
      screencast = {
        max_fps = 60;
        chooser_type = "dmenu";
        chooser_cmd = "${pkgs.rofi}/bin/rofi -dmenu -p 'Select a source to share:'";
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = cfg.defaultBrowser;
        "application/x-extension-htm" = cfg.defaultBrowser;
        "application/x-extension-html" = cfg.defaultBrowser;
        "application/x-extension-shtml" = cfg.defaultBrowser;
        "application/x-extension-xht" = cfg.defaultBrowser;
        "application/x-extension-xhtml" = cfg.defaultBrowser;
        "application/xhtml+xml" = cfg.defaultBrowser;
        "text/html" = cfg.defaultBrowser;
        "x-scheme-handler/about" = cfg.defaultBrowser;
        "x-scheme-handler/http" = cfg.defaultBrowser;
        "x-scheme-handler/https" = cfg.defaultBrowser;
        "x-scheme-handler/unknown" = cfg.defaultBrowser;
        "x-scheme-handler/discord-1216669957799018608" = "discord.desktop";
        "x-scheme-handler/discord-455712169795780630" = "discord.desktop";
        "x-scheme-handler/sgnl" = "signal.desktop";
        "x-scheme-handler/signalcaptcha" = "signal.desktop";
      };
    };

    custom.home.behavior.impermanence.paths = [
      "documents"
      "downloads"
      "pictures"
      "videos"
    ];
  };
}
