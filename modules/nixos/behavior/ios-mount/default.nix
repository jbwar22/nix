{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
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
