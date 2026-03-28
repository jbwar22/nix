{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  networking.interfaces.${config.custom.common.opts.hardware.interface.ethernet}.wakeOnLan = {
    enable = true;
  };
}
