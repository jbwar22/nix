{ inputs, clib, pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    gimp3
    element-desktop
    feh
    qpwgraph
    (clib.wrapWaylandElectron inputs pkgs pkgs.spotify)
    sqlitebrowser
    zoom-us
    mullvad-browser

    (inputs.wrappers.lib.wrapPackage ({ ... }: {
      inherit pkgs;
      package = pkgs.vlc;
      env = {
        DISPLAY = "";
      };
    }))
  ];
}
