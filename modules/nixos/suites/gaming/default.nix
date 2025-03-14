{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "suite of options specific to gaming";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos = {
      programs = {
        steam.enable = true;
        gamemode.enable = true;
      };
    };
  };
}
