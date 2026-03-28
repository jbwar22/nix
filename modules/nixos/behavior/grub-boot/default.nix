{ config, lib, ns, ... }:

with lib; ns.enable {
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
}
