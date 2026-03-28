{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  home.packages = with pkgs; [
    # jetbrains.pycharm-professional
    mssql_jdbc
    unixODBCDrivers.msodbcsql17
    libreoffice
  ];
}
