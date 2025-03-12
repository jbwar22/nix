{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt (mkOption {
    type = with types; attrsOf str;
    description = "aliases";
  });
}
