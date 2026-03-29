{ config, clib, pkgs, ns, ... }:

ns.enable {
  environment.etc."nixos" = {
    source = clib.myMkOutOfStoreSymlink pkgs config.custom.common.opts.hardware.configLocation;
  };
}
