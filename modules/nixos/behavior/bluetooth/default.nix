{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.behavior.bluetooth = ns; }) cfg opt;
in
{
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
