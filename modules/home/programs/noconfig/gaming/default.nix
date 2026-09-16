{ pkgs, ns, ... }:

ns.enable {
  home.packages = builtins.attrValues {
    inherit (pkgs)
    gamescope
    prismlauncher
    umu-launcher;
  };
  custom.home.behavior.impermanence.paths = [
    "games"
    ".local/share/umu"
    ".local/share/osu" # osu-lazer
    ".local/share/PrismLauncher"
  ];
}
