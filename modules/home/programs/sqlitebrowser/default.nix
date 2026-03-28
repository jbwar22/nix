{ pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    sqlitebrowser
  ];

  custom.home.behavior.impermanence.paths = [ ".config/sqlitebrowser" ];
}
