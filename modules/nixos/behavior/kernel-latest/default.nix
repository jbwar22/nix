{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
