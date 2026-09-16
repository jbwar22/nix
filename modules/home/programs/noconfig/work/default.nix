{ pkgs, ns, ... }:

ns.enable {
  home.packages = builtins.attrValues {
    inherit (pkgs)
    libreoffice
    mssql_jdbc;

    inherit (pkgs.unixodbcDrivers)
    msodbcsql17;
  };
}
