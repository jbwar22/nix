{ pkgs, ns, ... }:

ns.enable {
  home.packages = [
    pkgs.dolphin-emu
  ];

  custom.home.behavior.impermanence.paths = [
    ".local/share/dolphin-emu"
    { path = ".cache/dolphin-emu"; origin = "local"; }
  ];
}
