{ config, lib, ns, ... }:

ns.enable (let
  hf = config.custom.home.opts.hostfeatures;
in {
  services.udiskie.enable = lib.warnIf (!(hf.hasUdisks2)) "enabling udiskie without udisks2 enabled" true;
})
