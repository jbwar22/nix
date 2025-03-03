{ config, lib, pkgs, ... }:

with lib; with namespace config { home.programs.noconfig.work = ns; }; {
  options = opt {
    enable = mkEnableOption "additional programs for use at work";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
      # jetbrains.pycharm-professional
      mssql_jdbc
      unixODBCDrivers.msodbcsql17
    ];

    custom.home.opts.aliases = {
      # TODO
    };
  };
}
