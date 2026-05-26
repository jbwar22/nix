{ pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    wineWow64Packages.stable
    winetricks
  ];

  custom.home.behavior.impermanence.paths = [
    ".wine"
    { path = ".cache/wine"; origin = "local"; }
    { path = ".cache/winetricks"; origin = "local"; }
  ];
}
