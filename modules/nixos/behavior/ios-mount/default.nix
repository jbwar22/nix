{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { nixos.behavior.ios-mount = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "mounting ios devices";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      libimobiledevice
      ifuse
    ];

    services.usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
    
  };
}
