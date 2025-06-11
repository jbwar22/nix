{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    (wrapWaylandElectron signal-desktop-bin)
  ];

  # fix for needing to open it up twice
  xdg.desktopEntries = {
    signal = {
      name = "Signal";
      exec = "${pkgs.writeShellScript "launch-signal" ''
        ${pkgs.signal-desktop}/bin/signal-desktop &
        ${pkgs.coreutils}/bin/sleep 1
        ${pkgs.signal-desktop}/bin/signal-desktop $@
      ''} %U";
      terminal = false;
      type = "Application";
      icon = "signal-desktop";
      comment = "Private messaging from your desktop";
      mimeType = [ "x-scheme-handler/sgnl" "x-scheme-handler/signalcaptcha" ];
      categories = [ "Network" "InstantMessaging" "Chat" ];
      settings = {
        StartupWMClass = "signal";
      };
    };
  };

  custom.home.behavior.impermanence.dirs = [ ".config/Signal" ];
}
