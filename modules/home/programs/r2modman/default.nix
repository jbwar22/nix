{ pkgs, ns, ... }:

ns.enable {
  home.packages = [
    pkgs.r2modman
  ];

  custom.home.behavior.impermanence.paths = [
    ".config/r2modman"
    ".config/r2modmanPlus-local"
  ];
}
