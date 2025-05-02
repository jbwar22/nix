{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "systemd-boot";
    efiAtSlashBoot = mkEnableOption "efi at /boot";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = mkIf (!cfg.efiAtSlashBoot) "/boot/efi";
      };
    };
  };
}
