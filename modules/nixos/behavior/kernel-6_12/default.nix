{ pkgs, ns, ... }:

ns.enable {
  boot.kernelPackages = pkgs.linuxPackages_6_12;
}
