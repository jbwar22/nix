{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.vnstat.enable = true;

  environment.persistence = persistSysDirs config [ "/var/lib/vnstat" ];
}
