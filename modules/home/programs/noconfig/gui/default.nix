{ inputs, pkgs, ns, ... }:

let
  vlc = inputs.wrappers.lib.wrapPackage ({ ... }: {
    inherit pkgs;
    package = pkgs.vlc;
    env = {
      DISPLAY = "";
    };
  });
in ns.enable {
  home.packages = builtins.attrValues {
    inherit (pkgs)
    element-desktop
    feh
    gimp3
    mullvad-browser
    qpwgraph
    sqlitebrowser
    zoom-us;

    inherit
    vlc;
  };
}
