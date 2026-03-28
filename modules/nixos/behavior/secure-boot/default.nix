{ lib, pkgs, ns, ... }:

ns.enable {
  environment.systemPackages = with pkgs; [ sbctl ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  custom.nixos.behavior.impermanence.paths = [ "/var/lib/sbctl" ];
}
