{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.ntp.enable = true;
  time.timeZone = config.custom.nixos.opts.secrets.timeZone;

  custom.nixos.behavior.impermanence.files = mkIf (config.time.timeZone == null) [ "/etc/localtime" ];
}
