{ config, lib, ... }:

with lib; with ns config ./.; (let
  hf = config.custom.home.opts.hostfeatures;
in {
  options = opt {
    enable = mkEnableOption "home impermanence";
    dirs = mkOption {
      type = with types; listOf str;
      description = "extra dirs to persist";
      default = [];
    };
    files = mkOption {
      type = with types; listOf str;
      description = "extra files to persist";
      default = [];
    };
  };

  config = mkIf cfg.enable (opt {
    dirs = mkMerge [
      [
        ".ssh"
        ".cache/nix"
        ".cache/mesa_shader_cache"
        ".cache/mesa_shader_cache_db"
        ".local/share/home-manager"
        ".local/share/nix"
      ]
      (mkIf hf.hasDocker [ ".docker" ])
      (mkIf hf.hasFlatpak [ ".local/share/flatpak" ])
    ];
  });
})
