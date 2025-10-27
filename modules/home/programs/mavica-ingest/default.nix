{ inputs, config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = [
    inputs.mavica-scripts.packages.${pkgs.system}.default
  ];
  home.sessionVariables = {
    MAVICA_SCRIPTS_MAKE = "Sony";
    MAVICA_SCRIPTS_MODEL = "Mavica FD83";
    MAVICA_SCRIPTS_DEVICE = "/dev/disk/by-id/usb-TEACV0.0_TEACV0.0";
  };
}
