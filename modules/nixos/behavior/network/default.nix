{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  networking.networkmanager.enable = true;

  networking.useDHCP = lib.mkDefault true;

  custom.nixos.behavior.impermanence.dirs = [ "/etc/NetworkManager/system-connections" ];
}
