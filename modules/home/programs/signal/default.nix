{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  # extended from wrapWaylandElectron in lib.nix
  signal = (wrapAndAddFlags pkgs.signal-desktop-bin [
    "--wayland-text-input-version=3"
    "--disable-gpu"
  ]);
in {
  home.packages = [
    signal
  ];

  # fix for needing to open it up twice
  xdg.desktopEntries = {
    signal = {
      name = "Signal";
      exec = "${pkgs.writeShellScript "launch-signal" ''
        ${signal}/bin/signal-desktop &
        ${pkgs.coreutils}/bin/sleep 1
        ${signal}/bin/signal-desktop $@
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

  custom.home.behavior.impermanence.paths = [ ".config/Signal" ];
})
