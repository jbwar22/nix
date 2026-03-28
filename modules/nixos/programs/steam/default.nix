{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
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
