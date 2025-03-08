{ config, lib, ... }:

with lib; with namespace config { nixos.behavior.grub-boot = ns; }; {
  options = opt {
    enable = mkEnableOption "Whether to enable grub as the bootloader";
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        # theme = ./grub-theme;
        gfxmodeEfi = "1920x1080";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };
}
