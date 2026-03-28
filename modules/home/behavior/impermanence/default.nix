{ config, lib, ns, ... }:

with lib; with ns; (let
  hf = config.custom.home.opts.hostfeatures;
in {
  options = opt {
    enable = mkEnableOption "home impermanence";
    paths = mkOption {
      type = with types; listOf anything;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    custom.home.behavior.impermanence-subvolumes = {
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
        (mkIf hf.hasFlatpak [ ".local/share/flatpak" ])
      ];
    };
  };
})
