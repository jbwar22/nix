{ config, lib, ns, ... }:

with lib; ns.enable (let
  hf = config.custom.home.opts.hostfeatures;
in {
  services.udiskie.enable = warnIf (!(hf.hasUdisks2)) "enabling udiskie without udisks2 enabled" true;
})
