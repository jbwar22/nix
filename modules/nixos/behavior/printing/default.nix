{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "Whether to enable printing support";
  };
  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.avahi = {
      enable = mkDefault true;
      nssmdns4 = mkDefault true;
      openFirewall = mkDefault true;
    };
  };
}
