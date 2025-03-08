{ config, lib, ... }:

with lib; with namespace config { nixos.suites.gaming = ns; }; {
  options = opt {
    enable = mkEnableOption "suite of options specific to gaming";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos = {
      programs = {
        steam.enable = true;
      };
    };
  };
}
