{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  environment.systemPackages = with pkgs; [ sbctl ];

  custom.nixos.behavior.systemd-boot.efiAtSlashBoot = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  custom.nixos.behavior.impermanence.dirs = [ "/var/lib/sbctl" ];
}
