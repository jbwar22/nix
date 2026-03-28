{ config, lib, ns, ... }:

with lib; ns.enable {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  custom.nixos.behavior.impermanence.paths = [
    "/var/lib/blueman"
    "/var/lib/bluetooth"
  ];
}
