{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    dolphin-emu
  ];

  custom.home.behavior.impermanence.dirs = [
    ".local/share/dolphin-emu"
  ];
  custom.home.behavior.impermanence.dirsLocal = [
    ".cache/dolphin-emu"
  ];
}
