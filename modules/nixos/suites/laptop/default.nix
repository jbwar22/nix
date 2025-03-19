{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.nixos = {
    programs = {
      cpupower.enable = true;
    };
  };
}
