{ inputs, pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    gimp3
    element-desktop
    feh
    qpwgraph
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
