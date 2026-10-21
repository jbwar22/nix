{ pkgs, ns, ... }:

ns.enable {
  home.packages = builtins.attrValues {
    inherit (pkgs)
    freecad;
  };
}
