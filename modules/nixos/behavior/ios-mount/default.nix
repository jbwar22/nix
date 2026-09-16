{ pkgs, ns, ... }:

ns.enable {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
    libimobiledevice
    ifuse;
  };

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };
}
