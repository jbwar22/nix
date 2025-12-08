{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    quickshell
  ];

  programs.quickshell = {
    enable = true;
    configs = {
      default = ./config;
      # live-update config is meant for rapid testing, not actual usage
      live-update = config.lib.file.mkOutOfStoreSymlink (getConfigPath config ./config);
    };
  };
}
