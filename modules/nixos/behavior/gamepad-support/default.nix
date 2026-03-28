{ lib, pkgs, ns, ... }:

with lib; ns.enable {
  services.udev = {
    enable = mkDefault true;
    packages = with pkgs; [
      game-devices-udev-rules
    ];
  };
  hardware.uinput.enable = true;
}
