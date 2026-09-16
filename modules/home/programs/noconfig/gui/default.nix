{ inputs, pkgs, ns, ... }:

ns.enable {
  home.packages = [
    pkgs.gimp3
    pkgs.element-desktop
    pkgs.feh
    pkgs.qpwgraph
    pkgs.sqlitebrowser
    pkgs.zoom-us
    pkgs.mullvad-browser

    (inputs.wrappers.lib.wrapPackage ({ ... }: {
      inherit pkgs;
      package = pkgs.vlc;
      env = {
        DISPLAY = "";
      };
    }))
  ];
}
