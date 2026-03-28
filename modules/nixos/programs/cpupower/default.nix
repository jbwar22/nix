{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  environment.systemPackages = [ config.boot.kernelPackages.cpupower ];
}
