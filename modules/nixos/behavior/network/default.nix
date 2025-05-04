{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  networking.networkmanager.enable = true;

  networking.useDHCP = lib.mkDefault true;

  environment.persistence = persistSysDirs config [ "/etc/NetworkManager/system-connections" ];
}
