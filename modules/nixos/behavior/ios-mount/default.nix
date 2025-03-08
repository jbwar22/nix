{ config, lib, pkgs, ... }:

with lib; with namespace config { nixos.behavior.ios-mount = ns; }; {
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
