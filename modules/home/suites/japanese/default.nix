{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "options if using japanese input";
  };

  config = lib.mkIf cfg.enable {
    custom.home = {
      programs = {
        fcitx5.enable = true;
      };
    };
  };
}
