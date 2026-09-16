{ pkgs, ns, ... }:

ns.enable {
  home.packages = [
    pkgs.chromium
  ];

  custom.home.behavior.impermanence.paths = [ ".config/chromium" ];
}
