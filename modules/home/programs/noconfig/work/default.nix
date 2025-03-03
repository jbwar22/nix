{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { home.programs.noconfig.work = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "additional programs for use at work";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
      jetbrains.pycharm-professional
      mssql_jdbc
      unixODBCDrivers.msodbcsql17
    ];

    custom.home.opts.aliases = {
      # TODO
    };
  };
}
