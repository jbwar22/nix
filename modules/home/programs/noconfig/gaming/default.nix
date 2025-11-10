{ config, lib, pkgs, inputs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    (inputs.nix-gaming.packages.${pkgs.system}.osu-stable.override {
       location = "$HOME/games/osu/prefix";
    })
    gamescope
    umu-launcher
  ];
  custom.home.behavior.impermanence.dirs = [
    "games"
    ".local/share/umu"
    ".local/share/osu" # osu-lazer
  ];
}
