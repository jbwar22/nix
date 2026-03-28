{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  services.gnome-keyring.enable = true;

  custom.home.behavior.impermanence.paths = [
    ".local/share/keyrings"
  ];
}
