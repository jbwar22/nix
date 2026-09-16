{ lib, pkgs, ns, ... }:

ns.enable {
  services.udev = {
    enable = lib.mkDefault true;
    packages = [
      pkgs.game-devices-udev-rules
    ];
  };
  hardware.uinput.enable = true;
}
