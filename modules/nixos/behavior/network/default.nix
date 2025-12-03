{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  networking.networkmanager.enable = true;

  custom.nixos.behavior.impermanence.dirs = [ "/etc/NetworkManager/system-connections" ];
}
