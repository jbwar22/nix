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

  config = mkIf cfg.enable {
    home.persistence.${cfg.persistPath} = {
      enable = true;
      allowOther = hf.hasFuseAllowOther;
      directories = mkMerge [
        ([
          ".ssh"
          ".cache/nix"
          ".cache/mesa_shader_cache"
          ".cache/mesa_shader_cache_db"
          ".local/share/home-manager"
          ".local/share/nix"
          # ".pki"
        ] ++ cfg.dirs)
        (mkIf true [ ".docker" ])
        (mkIf true [ ".local/share/flatpak" ])
      ];
      files = cfg.files;
    };

    # TODO per-host
    home.file.".local/state/wireplumber/default-routes.hm-default" = mkIf hf.hasWireplumber {
      text = ''
        [default-routes]
        alsa_card.pci-0000_c1_00.6:output:analog-output-speaker={"channelMap":["FL", "FR"], "channelVolumes":[0.125000, 0.125000], "latencyOffsetNsec":0, "mute":true}
      '';
      onChange = ''
        cp ~/.local/state/wireplumber/default-routes.hm-default ~/.local/state/wireplumber/default-routes
        chmod 644 ~/.local/state/wireplumber/default-routes
      '';
    };
  };
})
