{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    dolphin-emu
  ];

  home.persistence = persistUserDirs config [
    ".cache/dolphin-emu"
    ".local/share/dolphin-emu"
  ];
}
