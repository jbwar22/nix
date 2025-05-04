{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.fprintd.enable = true;

  environment.persistence = persistSysDirs config [ "/var/lib/fprint" ];
}
