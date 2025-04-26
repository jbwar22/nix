pkgs: lib: config:

with lib; (let
  hf = config.custom.home.opts.hostfeatures;
in {
  screens = import ./screens.nix pkgs lib config;
  kill = import ./kill.nix pkgs;
  admin = mkIf hf.userIsAdmin (import ./admin.nix pkgs lib config);
})
