{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  hardware.graphics = {
    enable = true;
    # steam
    enable32Bit = true;

    package = pkgs.mesa_unstable;
  };

  environment.systemPackages = with pkgs; [
    dconf       # gtk
  ];
}
