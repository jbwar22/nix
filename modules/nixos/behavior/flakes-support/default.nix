{ config, lib, ...}:

with lib; with namespace config { nixos.behavior.flakes-support = ns; }; {
  options = opt {
    enable = mkEnableOption "Whether to enable flakes support";
  };

  config = mkIf cfg.enable {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
