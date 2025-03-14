{ config, lib, ...}:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "power management opitons for lenovo t480";
  };

  config = mkIf cfg.enable {
    services.tlp = {
      enable = true;
      settings = foldl' (accum: x: {
        "START_CHARGE_THRESH_${x.name}" = x.value.min;
        "STOP_CHARGE_THRESH_${x.name}" = x.value.max;
      }) {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      } (attrsToList config.custom.common.opts.hardware.batteries);
    };

    services.thermald.enable = true;
  };
}
