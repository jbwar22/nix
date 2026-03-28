{ inputs, lib, pkgs, ns, ... }:

with lib; ns.enable {
  home.packages = [
    (wrapWaylandElectron inputs pkgs spotify)
  ];

  custom.home.behavior.impermanence.paths = [ ".config/Slack" ];
}
