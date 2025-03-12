{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "default time settings";
  };
  config = lib.mkIf cfg.enable {
    services.ntp.enable = true;
    time.timeZone = config.custom.nixos.opts.secrets.timeZone;
  };
}
