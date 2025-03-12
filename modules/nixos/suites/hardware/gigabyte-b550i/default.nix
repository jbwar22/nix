{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "suite of options specific to gigabyte b550i aorus pro ax";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos = {
      hardware.system.gigabyte-b550i.enable = true;
    };
  };
}
