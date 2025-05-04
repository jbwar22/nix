{ config, lib, ... }:

with lib; with ns config ./.; (let
  hf = config.custom.home.opts.hostfeatures;
in {
  options = opt {
    enable = mkEnableOption "home impermanence";
    persistPath = mkOption {
      type = with types; path;
      description = "persist path";
    };
  };

  config = mkIf cfg.enable {
    home.persistence.${cfg.persistPath} = {
      enable = true;
      allowOther = hf.hasFuseAllowOther;
      directories = mkMerge [
        [
          ".ssh"
          ".cache/nix"
          ".cache/mesa_shader_cache"
          ".cache/mesa_shader_cache_db"
          ".local/share/home-manager"
          ".local/share/nix"
          # ".pki"
        ]
        (mkIf true [ ".docker" ])
        (mkIf true [ ".local/share/flatpak" ])
      ];
    };
  };
})
