{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.vnstat.enable = true;

  custom.nixos.behavior.impermanence.paths = [ "/var/lib/vnstat" ];
}
