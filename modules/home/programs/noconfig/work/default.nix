{ pkgs, ns, ... }:

ns.enable {
  home.packages = [
    # pkgs.jetbrains.pycharm-professional
    pkgs.mssql_jdbc
    pkgs.unixodbcDrivers.msodbcsql17
    pkgs.libreoffice
  ];
}
