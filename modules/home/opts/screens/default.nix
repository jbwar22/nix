{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.opts.screens = ns; }) cfg opt;

  sharedOptions = with types; {
    name = mkOption {
      type = str;
      description = "monitor name, not output name";
    };
    noserial = mkOption {
      type = bool;
      default = false;
      description = "monitor name excludes serial";
    };
    bar = mkOption {
      type = str;
      description = "bar type to use";
    };
    resolution = mkOption {
      type = str;
      description = "resolution and refresh rate";
    };
    position = mkOption {
      type = str;
      description = "absolute position";
    };
    vrr = mkOption {
      type = bool;
      default = false;
      description = "variable refresh rate";
    };
    wallpaper.mode = mkOption {
      type = str;
      default = "fill";
      description = "wallpaper mode";
    };
  };
in
{
  options = opt {
    definition = mkOption {
      type = with types; listOf (submodule {
        options = {
          inherit (sharedOptions) name noserial bar resolution position vrr;
          wallpaper.mode = sharedOptions.wallpaper.mode;
          wallpaper.file = mkOption {
            type = str;
            default = "";
            description = "filename (within wallpaper folder) of wallpaper";
          };
        };
      });
      description = "list of screen configs";
    };

    config = mkOption {
      type = with types; listOf (submodule {
        options = {
          inherit (sharedOptions) name noserial bar resolution position vrr;
          wallpaper.mode = sharedOptions.wallpaper.mode;
          wallpaper.path = mkOption {
            type = lib.types.path;
            default = config.custom.home.opts.wallpaper.path;
            description = "file path of wallpaper";
          };
        };
      });
      description = "list of screen configs (generated, do not set!)";
    };
  };

  config = opt {
    config = builtins.map (screen: {
      inherit (screen) name noserial bar resolution position vrr;
      # might not work for multiple monitors of the same name!
      wallpaper.mode = screen.wallpaper.mode;
      wallpaper.path = if (screen.wallpaper.file == "") then
        config.custom.home.opts.wallpaper.path
      else
        ../../../../secrets/git-crypt/wallpaper/${screen.wallpaper.file};
    }) cfg.definition;
  };

}
