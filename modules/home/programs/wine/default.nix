{ pkgs, ns, ... }:

ns.enable {
  home.packages = [
    pkgs.wineWow64Packages.stable
    pkgs.winetricks
  ];

  custom.home.behavior.impermanence.paths = [
    ".wine"
    { path = ".cache/wine"; origin = "local"; }
    { path = ".cache/winetricks"; origin = "local"; }
  ];
}
