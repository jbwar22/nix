{ config, lib, ...}:

with lib;
let
  inherit (namespace config { nixos.behavior.t480-power = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "power management opitons for lenovo t480";
  };

  config = mkIf cfg.enable {
    services.tlp = {
      enable = true;
      settings = let 
        thresh = foldl' (accum: x:
          accum // {
            "START_CHARGE_THRESH_${x.name}" = x.value.min;
            "STOP_CHARGE_THRESH_${x.name}" = x.value.max;
          }) {} (attrsToList config.custom.common.opts.hardware.batteries);
      in {} // thresh;
    };

    services.thermald.enable = true;
  };
}
