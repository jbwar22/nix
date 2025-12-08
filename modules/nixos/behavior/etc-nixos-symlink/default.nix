{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  environment.etc."nixos" = {
    source = myMkOutOfStoreSymlink pkgs config.custom.common.opts.hardware.configLocation;
  };
}
