{ pkgs, ns, ... }:

ns.enable {
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
