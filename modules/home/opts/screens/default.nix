{ config, lib, ... }:

with lib; with ns config ./.; let
  sway-output-option = mkOption {
    type = with types; attrsOf str;
    description = "sway output config";
  };
in {
  options = opt (mkOfSubmoduleOption "screen configs" types.attrsOf {
    sway = sway-output-option;
    specialisations = mkOption {
      description = "specialisations for shortcuts";
      type = with types; nullOr (attrsOf (submodule {
        options = {
          sway = sway-output-option;
        };
      }));
      default = null;
    };
    bar = mkStrOption "bar def name";
    noserial = mkEnableOption "screen name does not enclude serial number";
    clamshell = mkEnableOption "screen clamshell behavior";
  });

  config = opt {
    # desk center monitor
    "ASUSTek COMPUTER INC VG27AQL1A S1LMQS102258" = {
      sway.resolution = mkDefault "2560x1440@170.004Hz";
      bar = mkDefault "bar1440";
    };
    # desk left monitor
    "ASUSTek COMPUTER INC VG278 J8LMQS104073" = {
      sway.resolution = mkDefault "1920x1080@144.001Hz";
      bar = mkDefault "bar1080";
    };
    # desk right monitor
    "BNQ BenQ GW2780 V1J07047SL0" = {
      sway.resolution = mkDefault "1920x1080@60.000Hz";
      bar = mkDefault "bar1080";
    };
    # framework laptop screen
    "BOE NE135A1M-NY1" = {
      sway.resolution = mkDefault "2880x1920@120.000Hz";
      bar = mkDefault "bar1920_2x";
      noserial = mkDefault true;
    };
    # thinkpad laptop screen
    "BOE 0x06B3" = {
      sway.resolution = mkDefault "1366x768@60.058Hz";
      bar = mkDefault "bar768";
      noserial = mkDefault true;
    };


    # work desk monitor
    "Acer Technologies XV271U M3 140400E433LIJ" = {
      sway.resolution = mkDefault "2560x1440@143.999Hz";
      bar = mkDefault "bar1440";
    };
    # wall tv
    "LG Electronics LG TV 0x01010101" = {
      sway.resolution = mkDefault "1920x1080@60.000hz";
      bar = mkDefault "bar1080";
    };
    # spare monitor
    "Hewlett Packard HP 22cwa 6CM6120J0Z" = {
      sway.resolution = mkDefault "1920x1080@60.000hz";
      bar = mkDefault "bar1080";
    };
  };
}
