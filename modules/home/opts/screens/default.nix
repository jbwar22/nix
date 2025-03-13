{ config, lib, ... }:

with lib; with ns config ./.; let
  sway-output-option = mkOption {
    type = with types; attrsOf str;
    description = "sway output config";
  };
in {
  options = opt (mkOfSubmoduleOption "screen configs" types.attrsOf {
    sway = sway-output-option;
    specialisations = mkOfSubmoduleOption "specialisations for shortcuts" types.attrsOf {
      sway = sway-output-option;
    };
    bar = mkStrOption "bar def name";
    noserial = mkEnableOption "screen name does not enclude serial number";
  });
}
