{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { nixos.behavior.xdg-screenshare = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "xdg screenshare";
  };
  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      config = {
        common = {
          default = [ "wlr" ];
        };
      };
      wlr = {
        enable = true;
        settings = {
          screencast = {
            max_fps = 60;
            chooser_type = "simple";
            chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
          };
        };
      };
    };
  };
}
