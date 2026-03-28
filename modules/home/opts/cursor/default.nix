{ pkgs, lib, ns, ... }:

with ns; let
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
    "posy" = {
      name = "Posy_Cursor_Black_125_175";
      package = pkgs.posy-cursors;
      size = 32;
    };
  };
in {
  options = with lib; opt {
    definition = mkOption {
      type = types.str;
      description = "cursor name";
      default = "macos";
    };
    theme = mkOption {
      type = (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "name of cursor within package";
          };
          package = mkOption {
            type = types.package;
            description = "cursor package";
          };
          size = mkOption {
            type = types.int;
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
