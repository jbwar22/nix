{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.programs.direnv = ns; }) cfg opt;
in
{
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
