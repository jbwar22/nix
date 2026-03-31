{ pkgs, inputs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
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
