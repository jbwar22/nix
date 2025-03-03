{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.programs.vnstat = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "vnstat";
  };

  config = lib.mkIf cfg.enable {

    services.vnstat.enable = true;

  };
}
