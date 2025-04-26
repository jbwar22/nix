{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  environment.systemPackages = [ config.boot.kernelPackages.cpupower ];
}
