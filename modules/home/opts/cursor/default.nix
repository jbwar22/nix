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
      manifest = pkgs.writeText "manifest.toml" ''
        [input]
        theme = "theme_out"
        dir = "@sourceRoot@"

        [files]
        pointer     = "Fish_default.ani"
        help        = "Fish_default.ani"
        working     = "Fish_loading.ani"
        busy        = "Fish_loading.ani"
        precision   = "Fish_default.ani"
        text        = "Fish_text.ani"
        hand        = "Fish_default.ani"
        unavailable = "Fish_unavailable.ani"
        vert        = "Fish_vertical.ani"
        horz        = "Fish_horizontal.ani"
        dgn1        = "Fish_diagonal.ani"
        dgn2        = "Fish_diagonal2.ani"
        move        = "Fish_move.ani"
        alternate   = "Fish_default.ani"
        link        = "Fish_link.ani"
        person      = "Fish_default.ani"
        pin         = "Fish_default.ani"

        [sizes]
        pointer     = "64"
        help        = "64"
        working     = "64"
        busy        = "64"
        precision   = "64"
        text        = "64"
        hand        = "64"
        unavailable = "64"
        vert        = "64"
        horz        = "64"
        dgn1        = "64"
        dgn2        = "64"
        move        = "64"
        alternate   = "64"
        link        = "64"
        person      = "64"
        pin         = "64"
      '';
    in {
      name = "coldyhands_fish_cursor_pack";
      package = pkgs.stdenv.mkDerivation {
        pname = "coldyhands_fish_cursor_pack";
        version = "1.0.0";
        src = pkgs.requireFile {
          name = "fish_cursor_pack.zip";
          sha256 = "89e9830a3f6557d7711cebfa16fa7734e3c75c13ac8f4513d64e8ea6f45fe9ee";
          url = "https://ko-fi.com/s/fa2ec1591e";
          message = ''
            Using cursor "fish" requires Fish Cursor Pack from Coldyhands.
            Expected file: fish_cursor_pack.zip (renamed from "Fish Cursor Pack.zip")
          '';
        };
        sourceRoot = ".";
        nativeBuildInputs = [
          pkgs.unzip
          inputs.ani2xcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
        postUnpack = ''
          mkdir $sourceRoot/ani2xcursor
          cp ${manifest} $sourceRoot/ani2xcursor/manifest.toml
        '';
        postPatch = ''
          substituteInPlace $sourceRoot/ani2xcursor/manifest.toml \
            --replace-fail "@sourceRoot@" "$sourceRoot"
        '';
        buildPhase = ''
          ani2xcursor --resample nearest .
        '';
        installPhase = ''
          install -dm 0755 $out/share/icons/coldyhands_fish_cursor_pack
          cp -r out/theme_out/xcursor/* $out/share/icons/coldyhands_fish_cursor_pack
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
