{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "cpupower";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ config.boot.kernelPackages.cpupower ];

  };
}
