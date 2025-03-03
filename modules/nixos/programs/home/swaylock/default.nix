{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.programs.home.swaylock = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "required system options for home swaylock";
  };
  config = lib.mkIf cfg.enable {
    security.pam.services.swaylock = {};
    security.polkit.enable = mkDefault true;
  };
}
