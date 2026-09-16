{ pkgs, ns, ... }:

let
  inherit (pkgs)
  ifuse
  libimobiledevice
  usbmuxd2;
in ns.enable {
  environment.systemPackages = [
    libimobiledevice
    ifuse
  ];

  services.usbmuxd = {
    enable = true;
    package = usbmuxd2;
  };
}
