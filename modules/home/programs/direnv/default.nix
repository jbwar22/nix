{ config, lib, ... }:

with lib; with namespace config { home.programs.direnv = ns; }; {
  options = opt {
    enable = mkEnableOption "enable direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
