{ pkgs, ns, ... }:

ns.enable {
  home.packages = [
    pkgs.gamescope
    pkgs.umu-launcher
    pkgs.prismlauncher
  ];
  custom.home.behavior.impermanence.paths = [
    "games"
    ".local/share/umu"
    ".local/share/osu" # osu-lazer
    ".local/share/PrismLauncher"
  ];
}
