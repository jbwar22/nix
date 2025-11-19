{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    dconf  # gtk
    vulkan-tools
  ];
}
