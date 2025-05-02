{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock"; }
    ];
  };
}
