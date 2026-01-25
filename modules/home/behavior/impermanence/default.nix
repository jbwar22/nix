{ config, lib, ... }:

with lib; with ns config ./.; (let
  hf = config.custom.home.opts.hostfeatures;

  impermanentPathType = types.submodule {
    options = {
      path = mkStrOption "path";
      local = mkEnableOption "should the path live in /persist/local/root";
      neededForBoot = mkEnableOption "needed in early stages";
    };
  };
  impermanentOptType = with types; listOf (coercedTo str (x:
    if typeOf x == "string" then {
      path = x;
    } else x
  ) impermanentPathType);
in {
  options = opt {
    enable = mkEnableOption "home impermanence";
    dirs = mkOption {
      type = impermanentOptType;
      description = "extra dirs to persist, back";
      default = [];
    };
    files = mkOption {
      type = impermanentOptType;
      description = "extra files to persist, back";
      default = [];
    };
  };

  config = mkIf cfg.enable (opt {
    dirs = mkMerge [
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
