{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  boot.kernelPackages = pkgs.linuxPackages_zen;
}
