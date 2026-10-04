{ config, lib, ns, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (lib)
  mkIf
  mkMerge
  mkOption;
  inherit (lib.types)
  anything
  listOf;

  hf = config.custom.home.opts.hostfeatures;
in {
  options = eopt {
    paths = mkOption {
      type = listOf anything;
      default = [];
    };
  };

  config = ecfg {
    environment.impermanence-subvolumes = {
      enable = true;
      paths = mkMerge [
        cfg.paths
        [
          ".ssh"
          ".local/share/home-manager"
          ".local/share/nix"
          ".local/share/flatpak" # more than just flatpak, includes xdg portals stuff
          { path = ".cache/nix"; origin = "local"; }
          { path = ".cache/mesa_shader_cache"; origin = "local"; }
          { path = ".cache/mesa_shader_cache_db"; origin = "local"; }
        ]
        (mkIf hf.hasDocker [ ".docker" ])
        (mkIf hf.hasFlatpak [
          ".var/app"
        ])
      ];
    };

    home.activation.createTmp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      [[ -L "$HOME/tmp" ]] || run mkdir -p "$HOME/tmp"
    '';
  };
}
