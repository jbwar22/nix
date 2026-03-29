{ inputs, clib, pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    gimp3
    element-desktop
    feh
    qpwgraph
    (clib.wrapWaylandElectron inputs pkgs pkgs.spotify)
    sqlitebrowser
    vlc
    zoom-us
    mullvad-browser
  ];
}
