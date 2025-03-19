{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  environment.systemPackages = with pkgs; [
    openvpn
    networkmanager-openvpn
    wireguard-tools
  ];
}
