{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "home impermanence";
    persistPath = mkOption {
      type = with types; path;
      description = "persist path";
    };
  };

  config = mkIf cfg.enable {
    home.persistence.${cfg.persistPath} = {
      enable = true;
      allowOther = true;
    };
  };
}
