{ config, lib, pkgs, inputs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    wineWowPackages.staging
    # wineWowPackages.waylandFull
    (inputs.nix-gaming.packages.${pkgs.system}.osu-stable.override {
       location = "$HOME/games/osu/prefix";
    })
  ];
  custom.home.behavior.impermanence.dirs = [
    "gaming"
    ".local/share/umu"
    ".local/share/osu" # osu-lazer
  ];
}
