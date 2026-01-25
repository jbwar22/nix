{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  slack = wrapWaylandElectron pkgs.slack;
  slack-x11 = (wrapAndAddFlags pkgs.slack [
    "--ozone-platform=x11"
  ]);
in {
  home.packages = [
    slack
  ];

  xdg.desktopEntries.slack-x11 = {
    name = "Slack (X11 mode)";
    exec = "${slack-x11}/bin/slack";
  };

  custom.home.behavior.impermanence.paths = [ ".config/Slack" ];
})
