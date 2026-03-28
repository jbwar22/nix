{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  environment.etc."nixos" = {
    source = myMkOutOfStoreSymlink pkgs config.custom.common.opts.hardware.configLocation;
  };
}
