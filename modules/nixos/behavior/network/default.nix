{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  networking.networkmanager.enable = true;

  custom.nixos.behavior.impermanence.paths = [ "/etc/NetworkManager/system-connections" ];
}
