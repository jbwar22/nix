{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    # dolphin-emu
  ];

  custom.home.behavior.impermanence.dirs = [
    ".cache/dolphin-emu"
    ".local/share/dolphin-emu"
  ];
}
