{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  home.packages = with pkgs; [
    sqlitebrowser
  ];

  custom.home.behavior.impermanence.paths = [ ".config/sqlitebrowser" ];
}
