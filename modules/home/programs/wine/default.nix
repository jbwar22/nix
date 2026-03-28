{ pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    wineWowPackages.stable
    winetricks
  ];

  custom.home.behavior.impermanence.paths = [
    ".wine"
    { path = ".cache/wine"; origin = "local"; }
    { path = ".cache/winetricks"; origin = "local"; }
  ];
}
