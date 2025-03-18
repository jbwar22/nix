{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt (mkOption {
    default = {};
    type = with types; attrsOf anything;
    description = "record of setHMOpt settings from nixos to home-manager by user";
  });
}
