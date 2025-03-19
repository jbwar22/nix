{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    slack
    # jetbrains.pycharm-professional
    mssql_jdbc
    unixODBCDrivers.msodbcsql17
  ];

  custom.home.opts.aliases = {
    # TODO
  };
}
