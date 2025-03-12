{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "bluetooth";
  };

  config = lib.mkIf cfg.enable {

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    services.blueman.enable = true;

  };
}
