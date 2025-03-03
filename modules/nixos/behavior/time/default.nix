{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.behavior.time = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "default time settings";
  };
  config = lib.mkIf cfg.enable {
    services.ntp.enable = true;
    time.timeZone = config.custom.nixos.opts.secrets.timeZone;
  };
}
