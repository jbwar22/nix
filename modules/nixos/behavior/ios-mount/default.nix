{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse
  ];

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };
}
