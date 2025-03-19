{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.printing.enable = true;
  services.avahi = {
    enable = mkDefault true;
    nssmdns4 = mkDefault true;
    openFirewall = mkDefault true;
  };
}
