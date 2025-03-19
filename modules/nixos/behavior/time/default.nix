{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.ntp.enable = true;
  time.timeZone = config.custom.nixos.opts.secrets.timeZone;
}
