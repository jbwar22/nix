{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    dolphin-emu
  ];

  custom.home.behavior.impermanence.paths = [
    ".local/share/dolphin-emu"
    { path = ".cache/dolphin-emu"; origin = "local"; }
  ];
}
