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
          local = mkEnableOption "should the path live in /persist/local/root";
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
        { path = ".cache/nix"; local = true; }
        { path = ".cache/mesa_shader_cache"; local = true; }
        { path = ".cache/mesa_shader_cache_db"; local = true; }
      ]
      (mkIf hf.hasDocker [ ".docker" ])
      (mkIf hf.hasFlatpak [ ".local/share/flatpak" ])
    ];
  });
})
