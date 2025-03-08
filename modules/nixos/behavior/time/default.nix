{ config, lib, ... }:

with lib; with namespace config { nixos.behavior.time = ns; }; {
  options = opt {
    enable = mkEnableOption "default time settings";
  };
  config = lib.mkIf cfg.enable {
    services.ntp.enable = true;
    time.timeZone = config.custom.nixos.opts.secrets.timeZone;
  };
}
