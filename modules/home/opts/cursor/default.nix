{ inputs, pkgs, lib, ns, ... }:

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
    "fish" = let
      size = 64;
    in {
      inherit size;
      name = "coldyhands_fish_cursor_pack";
      package = pkgs.callPackage ./ani2xcursor.nix {
        ani2xcursor = inputs.ani2xcursor.packages.${pkgs.stdenv.hostPlatform.system}.default;
        name = "coldyhands_fish_cursor_pack";
        filename = "fish_cursor_pack.zip";
        url = "https://ko-fi.com/s/fa2ec1591e";
        message = ''
          Using cursor "fish" requires Fish Cursor Pack from Coldyhands.
          Expected file: fish_cursor_pack.zip (renamed from "Fish Cursor Pack.zip")
        '';
        sha256 = "89e9830a3f6557d7711cebfa16fa7734e3c75c13ac8f4513d64e8ea6f45fe9ee";
        manifestSettings = {
          files = {
            default = "Fish_default.ani";
            working = "Fish_loading.ani";
            busy = "Fish_loading.ani";
            text = "Fish_text.ani";
            unavailable = "Fish_unavailable.ani";
            vert = "Fish_vertical.ani";
            horz = "Fish_horizontal.ani";
            dgn1 = "Fish_diagonal.ani";
            dgn2 = "Fish_diagonal2.ani";
            move = "Fish_move.ani";
            link = "Fish_link.ani";
          };
          sizes.default = toString size;
        };
      };
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
