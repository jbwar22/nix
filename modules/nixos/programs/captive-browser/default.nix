{ config, ns, ... }:

ns.enable {
  programs.captive-browser = {
    enable = true;
    interface = config.custom.common.opts.hardware.interface.wifi;
  };
}
