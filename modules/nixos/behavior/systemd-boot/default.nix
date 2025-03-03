{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.behavior.systemd-boot = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "systemd-boot bootloader";
  };
  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
