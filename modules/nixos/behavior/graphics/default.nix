{ config, lib, pkgs, ... }:

with lib; with namespace config { nixos.behavior.graphics = ns; }; {
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
