{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "gamemode";
  };

  config = lib.mkIf cfg.enable {

    programs.gamemode.enable = true;

  };
}
