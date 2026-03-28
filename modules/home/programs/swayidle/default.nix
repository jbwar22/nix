{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock"; }
    ];
  };
}
