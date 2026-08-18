{ config, lib, ns, ... }:

with lib; with ns; (let
  hf = config.custom.home.opts.hostfeatures;
in {
  options = eopt {
    paths = mkOption {
      type = with types; listOf anything;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    environment.impermanence-subvolumes = {
      enable = true;
      paths = mkMerge [
        cfg.paths
        [
          ".ssh"
          ".local/share/home-manager"
          ".local/share/nix"
          { path = ".cache/nix"; origin = "local"; }
          { path = ".cache/mesa_shader_cache"; origin = "local"; }
          { path = ".cache/mesa_shader_cache_db"; origin = "local"; }
        ]
        (mkIf hf.hasDocker [ ".docker" ])
        (mkIf hf.hasFlatpak [
          ".local/share/flatpak"
          ".var/app"
        ])
      ];
    };

    home.activation.createTmp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      [[ -L "$HOME/tmp" ]] || run mkdir -p "$HOME/tmp"
    '';
  };
})
