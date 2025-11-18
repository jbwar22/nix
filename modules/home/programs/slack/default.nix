{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  slack = (wrapAndAddFlags pkgs.slack [
    "--ozone-platform=x11" # wayland often doesn't launch for slack :/
  ]);
in {
  home.packages = [
    slack
  ];

  xdg.desktopEntries.slack-fix-wayland = {
    name = "Slack (Wayland Fix)";
    exec = "${pkgs.writeShellScript "slack-fix-wayland" ''
      ${slack}/bin/slack --ozone-platform=x11 &
      ${pkgs.coreutils}/bin/sleep 5
      ${pkgs.sway}/bin/swaymsg [class=Slack] kill
      ${pkgs.coreutils}/bin/sleep 1
      ${pkgs.procps}/bin/pkill -9 slack
      ${pkgs.coreutils}/bin/sleep 1
      ${slack}/bin/slack --ozone-platform=wayland $@
    ''} %u";
  };

  custom.home.behavior.impermanence.dirs = [ ".config/Slack" ];
})
