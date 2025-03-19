{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse
  ];

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };
}
