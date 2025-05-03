{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.fprintd.enable = true;

  environment.persistence = persistSysDirs [ "/var/lib/fprint" ];
}
