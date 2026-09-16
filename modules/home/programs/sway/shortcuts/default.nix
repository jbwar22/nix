pkgs: lib: config:

let
  hf = config.custom.home.opts.hostfeatures;
in {
  screens = import ./screens.nix pkgs lib config;
  kill = import ./kill.nix pkgs;
  admin = lib.mkIf hf.userIsAdmin (import ./admin.nix pkgs lib config);
}
