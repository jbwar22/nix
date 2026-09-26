{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
  ];

  config = {
    custom.nixos = {
      suites = {
        hardware.lenovo-t480.enable = true;

        pc.enable = true;
        laptop.enable = true;
        gaming.enable = true;
      };

      behavior = {
        systemd-boot.enable = true;
        kernel.default = pkgs.linuxPackages_6_18;
      };

      programs = {
        snapserver.enable = true;
      };
    };

    networking.hostName = "widow";

    system.stateVersion = "23.11";
  };
}
