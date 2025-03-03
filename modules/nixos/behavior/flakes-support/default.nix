{ config, lib, ...}:

with lib;
let
  inherit (namespace config { nixos.behavior.flakes-support = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "Whether to enable flakes support";
  };

  config = mkIf cfg.enable {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
