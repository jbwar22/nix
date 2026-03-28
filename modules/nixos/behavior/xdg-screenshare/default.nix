{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
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
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f \"Monitor: %o\" -or";
        };
      };
    };
  };
}
