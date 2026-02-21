{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=lz4"
    "zswap.max_pool_percent=20"
    "zswap.shrinker_enabled=1"
  ];

  boot.kernelModules = [ "lz4" ];
  boot.initrd.kernelModules = [ "lz4" ];
}
