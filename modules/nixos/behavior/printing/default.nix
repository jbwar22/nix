{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.behavior.printing = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "Whether to enable printing support";
  };
  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
