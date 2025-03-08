{ config, lib, ... }:

with lib; with namespace config { nixos.suites.hardware.lenovo-t480 = ns; }; {
  options = opt {
    enable = mkEnableOption "suite of options specific to lenovo t480";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos = {
      hardware.system.lenovo-t480.enable = true;

      behavior = {
        t480-rebinds.enable = true;
        t480-power.enable = true;
      };
    };
  };
}
