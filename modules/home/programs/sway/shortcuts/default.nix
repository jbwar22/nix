pkgs: lib: config:

with lib; {
  screens = import ./screens.nix pkgs lib config;
  kill = import ./kill.nix pkgs;
}
