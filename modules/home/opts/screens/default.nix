{ lib, clib, ns, ... }:

let
  inherit (ns)
  opt;
  inherit (clib)
  mkEachDefault
  mkStrOption;
  inherit (lib)
  attrValues
  flatten
  foldl
  imap0
  listToAttrs
  mapAttrs
  min
  mkEnableOption
  mkOption
  pipe
  recursiveUpdate
  splitString
  toInt
  types;
  inherit (types)
  attrsOf
  nullOr
  str
  submodule;

  sway-output-option = mkOption {
    type = attrsOf str;
    description = "sway output config";
  };
in {
  options = opt (mkOption {
    description = "screen configs";
    type = attrsOf (submodule {
      options = {
        sway = sway-output-option;
        specialisations = mkOption {
          description = "specialisations for shortcuts";
          type = nullOr (attrsOf (submodule {
            options = {
              sway = sway-output-option;
            };
          }));
          default = null;
        };
        bar = mkStrOption "bar def name";
        noserial = mkEnableOption "screen name does not enclude serial number";
        clamshell = mkEnableOption "screen clamshell behavior";
      };
    });
    apply = screens: let
      toXY = position: pipe position [
        (splitString " ")
        (imap0 (i: v: {
          name = if i == 0 then "x" else "y";
          value = toInt v;
        }))
        listToAttrs
      ];
      fromXY = posxy: "${toString posxy.x} ${toString posxy.y}";

      extractPos = v: if v.sway?position then [v.sway.position] else [];
      offset = pipe screens [
        attrValues
        (map (v:
          (extractPos v)
          ++ (if v.specialisations != null then (pipe v.specialisations [
            attrValues
            (map extractPos)
          ]) else [])
        ))
        flatten
        (map toXY)
        (foldl (accum: posxy: {
          x = min accum.x posxy.x;
          y = min accum.y posxy.y;
        }) { x = 0; y = 0; })
      ];

      hasOffset = offset.x != 0 || offset.y != 0;

      fixPos = position: pipe position [
        toXY
        (posxy: {
          x = posxy.x - offset.x;
          y = posxy.y - offset.y;
        })
        fromXY
      ];

      fixedScreens = mapAttrs (_name: screen-def: pipe screen-def [
        (screen-def:
          if screen-def.sway?position
          then recursiveUpdate screen-def {
            sway.position = fixPos screen-def.sway.position;
          }
          else screen-def
        )
        (screen-def:
          if screen-def.specialisations != null
          then recursiveUpdate screen-def {
            specialisations = (mapAttrs (_name: spec-def:
              if spec-def.sway?position
              then recursiveUpdate spec-def {
                sway.position = fixPos spec-def.sway.position;
              }
              else spec-def
            ) screen-def.specialisations);
          }
          else screen-def
        )
      ]) screens;
    in (
      if hasOffset
      then fixedScreens
      else screens
    );
  });

  config = opt (mkEachDefault {
    # home desk center monitor
    "ASUSTek COMPUTER INC VG27AQL1A S1LMQS102258" = {
      sway.resolution = "2560x1440@170.004Hz";
      bar = "bar1440";
    };
    # home desk left monitor
    "ASUSTek COMPUTER INC VG278 J8LMQS104073" = {
      sway.resolution = "1920x1080@144.001Hz";
      bar = "bar1080";
    };
    # home desk right monitor
    "BNQ BenQ GW2780 V1J07047SL0" = {
      sway.resolution = "1920x1080@60.000Hz";
      bar = "bar1080";
    };
    # framework laptop screen
    "BOE NE135A1M-NY1" = {
      sway.resolution = "2880x1920@120.000Hz";
      bar = "bar1920_2x";
      noserial = true;
    };
    # thinkpad laptop screen
    "BOE 0x06B3" = {
      sway.resolution = "1366x768@60.058Hz";
      bar = "bar768";
      noserial = true;
    };
    # work desk center monitor
    "Acer Technologies XV271U M3 140400E433LIJ" = {
      sway.resolution = "2560x1440@143.999Hz";
      bar = "bar1440";
    };
    # basement wall tv
    "LG Electronics LG TV 0x01010101" = {
      sway.resolution = "1920x1080@60.000hz";
      bar = "bar1080";
    };
    # spare monitor (21.5" HP)
    "Hewlett Packard HP 22cwa 6CM6120J0Z" = {
      sway.resolution = "1920x1080@60.000hz";
      bar = "bar1080";
    };
  });
}
