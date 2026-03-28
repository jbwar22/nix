{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  home.packages = with pkgs; [
    chromium
  ];

  custom.home.behavior.impermanence.paths = [ ".config/chromium" ];
}
