{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.fprintd.enable = true;

  custom.nixos.behavior.impermanence.paths = [ "/var/lib/fprint" ];
}
