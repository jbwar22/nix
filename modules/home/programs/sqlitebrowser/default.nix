{ pkgs, ns, ... }:

ns.enable {
  home.packages = [
    pkgs.sqlitebrowser
  ];

  custom.home.behavior.impermanence.paths = [ ".config/sqlitebrowser" ];
}
