{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
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
