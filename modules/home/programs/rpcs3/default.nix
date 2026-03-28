{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  home.packages = with pkgs; [
    rpcs3
  ];

  custom.home.behavior.impermanence.paths = [
    { path = ".cache/rpcs3"; origin = "local"; }
  ];
}
