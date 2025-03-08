{ config, lib, ... }:

with lib; with namespace config { nixos.behavior.bluetooth = ns; }; {
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
