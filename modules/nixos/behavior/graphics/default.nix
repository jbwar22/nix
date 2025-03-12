{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "graphics support";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      # steam
      enable32Bit = true;
    };

    environment.systemPackages = with pkgs; [
      dconf       # gtk
    ];
  };
}
