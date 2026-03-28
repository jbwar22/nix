{ config, ns, ... }:

ns.enable {
  networking.interfaces.${config.custom.common.opts.hardware.interface.ethernet}.wakeOnLan = {
    enable = true;
  };
}
