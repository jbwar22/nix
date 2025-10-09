{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  services.sunshine = {
    enable = true;
    autoStart = false;
    openFirewall = true;
    capSysAdmin = true;
  };

  # TODO fix
  # boot.extraModulePackages = with config.boot.kernelPackages; [ evdi ];
  # boot.kernelModules = [ "evdi" ];
}
