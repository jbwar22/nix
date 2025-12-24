{ config, lib, pkgs, inputs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    (inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable.override {
       location = "$HOME/games/osu/prefix";
       umu-launcher = pkgs.umu-launcher; # nix-gaming version deprecated
    })
    gamescope
    umu-launcher
    prismlauncher
  ];
  custom.home.behavior.impermanence.dirs = [
    "games"
    ".local/share/umu"
    ".local/share/osu" # osu-lazer
    ".local/share/PrismLauncher"
  ];
}
