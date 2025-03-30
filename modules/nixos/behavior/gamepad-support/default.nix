{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  services.udev = {
    enable = mkDefault true;
    packages = with pkgs; [
      game-devices-udev-rules
    ];
  };
  hardware.uinput.enable = true;
}
