{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.vnstat.enable = true;

  custom.nixos.behavior.impermanence.dirs = [ "/var/lib/vnstat" ];
}
