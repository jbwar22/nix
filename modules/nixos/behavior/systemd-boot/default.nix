{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "systemd-boot";
    efiAtSlashBoot = mkEnableOption "efi at /boot";
    fixResolution = mkEnableOption "consolemode -> auto";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
        consoleMode = mkIf cfg.fixResolution "auto";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = mkIf (!cfg.efiAtSlashBoot) "/boot/efi";
      };
    };
  };
}
