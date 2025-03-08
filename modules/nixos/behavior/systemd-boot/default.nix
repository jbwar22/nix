{ config, lib, ... }:

with lib; with namespace config { nixos.behavior.systemd-boot = ns; }; {
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
