{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.suites.work = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "suite of options specific to work";
  };

  config = lib.mkIf cfg.enable {

  };
}
