{ config, lib, pkgs, inputs, ns, ... }:

with lib; ns.enable {
  home.packages = with pkgs; [
    (inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable.override {
       location = "$HOME/games/osu/prefix";
    })
    gamescope
    umu-launcher
    prismlauncher
  ];
  custom.home.behavior.impermanence.paths = [
    "games"
    ".local/share/umu"
    ".local/share/osu" # osu-lazer
    ".local/share/PrismLauncher"
  ];
}
