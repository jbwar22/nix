{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      gamescope
      mangohud
      gamemode
    ];
    extest.enable = true; # steam input on wayland
    localNetworkGameTransfers.openFirewall = true;
  };
}
