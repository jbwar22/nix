{ config, lib, ...}:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "Whether to enable flakes support";
  };

  config = mkIf cfg.enable {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
