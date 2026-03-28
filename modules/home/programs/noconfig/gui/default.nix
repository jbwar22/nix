{ lib, pkgs, ns, ... }:

with lib; ns.enable {
  home.packages = with pkgs; [
    gimp3
    element-desktop
    feh
    qpwgraph
    (wrapWaylandElectron spotify)
    sqlitebrowser
    vlc
    zoom-us
    mullvad-browser
  ];
}
