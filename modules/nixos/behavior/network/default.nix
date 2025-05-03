{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  networking.networkmanager.enable = true;

  networking.useDHCP = lib.mkDefault true;

  environment.persistence = persistSysDirs [ "/etc/NetworkManager/system-connections" ];
}
