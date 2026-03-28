{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  home.packages = with pkgs; [
    ente-auth
  ];

  custom.home.behavior.impermanence.paths = [
    ".local/share/io.ente.auth"
  ];
}
