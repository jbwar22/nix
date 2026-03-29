{ inputs, clib, pkgs, ns, ... }:

ns.enable {
  home.packages = [
    (clib.wrapWaylandElectron inputs pkgs pkgs.slack)
  ];

  custom.home.behavior.impermanence.paths = [ ".config/Slack" ];
}
