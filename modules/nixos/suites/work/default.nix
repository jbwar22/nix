{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "suite of options specific to work";
  };

  config = lib.mkIf cfg.enable {

  };
}
