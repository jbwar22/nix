{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "firefox";
    defaultBrowser = mkOption {
      description = "default browser desktop file";
      type = types.str;
      default = "librewolfprofile.desktop";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xdg-utils
    ];

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
    };

    xdg.systemDirs = {
      data = [ "/etc/profiles/per-user/${config.home.username}/share" ];
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      xdgOpenUsePortal = true;
      config = {
        sway.default   = [ "wlr" ];
        common.default = [ "wlr" ];
      };
    };


    xdg.configFile."xdg-desktop-portal-wlr/config".text = generators.toINI {} {
      screencast = {
        max_fps = 60;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f \"Monitor: %o\" -or";
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

    custom.home.behavior.impermanence.dirs = [
      "documents"
      "downloads"
      "pictures"
      "videos"
    ];
  };
}
