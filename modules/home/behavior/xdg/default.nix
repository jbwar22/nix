{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
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
    createDirectories = true;
  };

  xdg.systemDirs = {
    data = [ "/etc/profiles/per-user/${config.home.username}/share" ];
  };

  xdg.portal = {
    enable = true; # TODO fix
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
    config = {
      sway.default   = [ "wlr" ];
      common.default = [ "wlr" ];
    };
  };


  xdg.configFile."xdg-desktop-portal-wlr/config".text = generators.toINI {} {
    screencast = {
      max_fps = 60;
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    };
  };

  custom.home.behavior.impermanence.dirs = [
    "documents"
    "downloads"
    "pictures"
    "videos"
  ];
}
