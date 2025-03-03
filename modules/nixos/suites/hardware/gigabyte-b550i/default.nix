{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.suites.hardware.gigabyte-b550i = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "suite of options specific to gigabyte b550i aorus pro ax";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos = {
      hardware.system.gigabyte-b550i.enable = true;
    };
  };
}
