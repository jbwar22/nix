{ pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    # jetbrains.pycharm-professional
    mssql_jdbc
    unixodbcDrivers.msodbcsql17
    libreoffice
  ];
}
