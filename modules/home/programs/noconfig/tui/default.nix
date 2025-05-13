{ config, lib, pkgs, inputs, outputs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    htop
    btop
    pulsemixer
    inputs.home-manager.packages.${pkgs.system}.default
    inputs.agenix.packages.${pkgs.system}.default
  ];
}
