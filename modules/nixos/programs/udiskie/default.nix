{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.programs.udiskie = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "auto mount flash drives";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.runXdgAutostartIfNone = mkDefault true;
    services.udisks2.enable = true;
  };
}
