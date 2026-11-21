{ pkgs, lib, ns, ... }:

let
  inherit (ns)
  cfg
  opt;
  inherit (lib)
  mkOption;
  inherit (lib.types)
  int
  package
  str
  submodule;

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
    "fish" = {
      name = "coldyhands_fish_cursor_pack";
      package = pkgs.stdenv.mkDerivation {
        pname = "coldyhands_fish_cursor_pack";
        version = "1.0.0";
        src = pkgs.requireFile {
          name = "coldyhands_fish_cursor_pack.tar.gz";
          sha256 = "ea221941041eb38abd77d4379760d3137db90c0fd7d349a98c059b3d712b88da";
          message = ''
            Using cursor "fish" requires Fish Cursor Pack from Coldyhands.
            Expected file: pack built with ani2xcursor as .tar.gz
          '';
        };
        installPhase = ''
          install -dm 0755 $out/share/icons/coldyhands_fish_cursor_pack
          cp -r xcursor/* $out/share/icons/coldyhands_fish_cursor_pack
        '';
      };
      size = 32;
    };
  };
in {
  options = opt {
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
