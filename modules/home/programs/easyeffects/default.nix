{ inputs, lib, ns, ... }:

with lib; with ns; {
  options = opt {
    enable = mkEnableOption "easyeffects";
    preset = mkOption {
      description = "preset";
      type = with types; nullOr str;
      default = null;
    };
  };
  config = mkIf cfg.enable {
    services.easyeffects = {
      enable = true;
      preset = mkIf (cfg.preset != null) cfg.preset;
    };

    xdg.configFile = {
      "easyeffects/output/gracefu.json" = mkIf (cfg.preset == "gracefu") {
        source = "${inputs.framework-dsp}/config/output/Gracefu's Edits.json";
      };
    };
  };
}
