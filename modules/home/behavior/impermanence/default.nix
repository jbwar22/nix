{ config, lib, ... }:

with lib; with ns config ./.; (let
  hf = config.custom.home.opts.hostfeatures;
in {
  options = opt {
    enable = mkEnableOption "home impermanence";
    paths = mkOption {
      type = with types; listOf (coercedTo str (x:
        if typeOf x == "string" then {
          path = x;
        } else x
      ) (submodule {
        options = {
          path = mkStrOption "path";
          file = mkEnableOption "is the path a file rather than a dir";
          origin = mkOption {
            type = nullOr str;
            description = "origin of path";
            default = null;
          };
          neededForBoot = mkEnableOption "needed in early stages";
        };
      }));
      description = "extra paths to persist, back";
      default = [];
    };
  };

  config = mkIf cfg.enable (opt {
    paths = mkMerge [
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
  });
})
