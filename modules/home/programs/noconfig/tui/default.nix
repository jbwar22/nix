{ config, lib, pkgs, inputs, outputs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    htop
    pulsemixer
    vim
    outputs.packages.${pkgs.system}.nixvim
    inputs.home-manager.packages.${pkgs.system}.default
    inputs.agenix.packages.${pkgs.system}.default
  ];
}
