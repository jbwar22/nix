{ inputs, clib, pkgs, ns, ... }:

ns.enable {
  home.packages = [
    (clib.wrapWaylandElectron inputs pkgs pkgs.spotify)
  ];

  custom.home.behavior.impermanence.paths = [ ".config/spotify" ];
}
