{ inputs, lib, ns, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (inputs)
  framework-dsp;
  inherit (lib)
  mkIf
  mkOption;
  inherit (lib.types)
  nullOr
  str;
in {
  options = eopt {
    preset = mkOption {
      description = "preset";
      type = nullOr str;
      default = null;
    };
  };
  config = ecfg {
    services.easyeffects = {
      enable = true;
      preset = mkIf (cfg.preset != null) cfg.preset;
    };

    xdg.configFile = {
      "easyeffects/output/gracefu.json" = mkIf (cfg.preset == "gracefu") {
        source = "${framework-dsp}/config/output/Gracefu's Edits.json";
      };
    };
  };
}
