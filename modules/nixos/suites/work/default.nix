{ config, lib, ... }:

with lib; with namespace config { nixos.suites.work = ns; }; {
  options = opt {
    enable = mkEnableOption "suite of options specific to work";
  };

  config = lib.mkIf cfg.enable {

  };
}
