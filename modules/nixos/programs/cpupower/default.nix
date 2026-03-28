{ config, ns, ... }:

ns.enable {
  environment.systemPackages = [ config.boot.kernelPackages.cpupower ];
}
