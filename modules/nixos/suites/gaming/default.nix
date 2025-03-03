{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.suites.gaming = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "suite of options specific to gaming";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos = {
      programs = {
        steam.enable = true;
      };
    };
  };
}
