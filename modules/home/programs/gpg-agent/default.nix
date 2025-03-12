{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "gpg-agent";
  };

  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
    };
  };
}
