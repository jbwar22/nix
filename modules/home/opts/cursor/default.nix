{ pkgs, config, lib, ... }:

with lib; with ns config ./.; let
  cursors = {
    "macos" = { # the only one that's small enough at size 24?
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 24;
    };
    "banana" = {
      name = "Banana";
      package = pkgs.banana-cursor;
      size = 24;
    };
    "adwaita" = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
    };
    "bibata" = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
in {
  options = with types; opt {
    definition = mkOption {
      type = str;
      description = "cursor name";
      default = "macos";
    };
    theme = mkOption {
      type = (submodule {
        options = {
          name = mkOption {
            type = str;
            description = "name of cursor within package";
          };
          package = mkOption {
            type = package;
            description = "cursor package";
          };
          size = mkOption {
            type = int;
            description = "cursor size";
          };
        };
      });
      description = "theme for use";
    };
  };

  config = opt {
    theme = {
      name = cursors.${cfg.definition}.name;
      package = cursors.${cfg.definition}.package;
      size = cursors.${cfg.definition}.size;
    };
  };
}
