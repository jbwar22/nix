{ config, lib, pkgs, inputs, outputs, ns, ... }:

with lib; ns.enable {
  home.packages = with pkgs; [
    htop
    btop
    pulsemixer
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
