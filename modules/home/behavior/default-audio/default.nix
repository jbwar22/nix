{ config, lib, ... }:

with lib; with ns config ./.; (let
  hf = config.custom.home.opts.hostfeatures;
in {
  options = opt {
    enable = mkEnableOption "default audio wireplumber config";
    default-routes = mkOption {
      type = types.lines;
      description = "text";
    };
  };

  config = mkIf cfg.enable {
    home.file.".local/state/wireplumber/default-routes.hm-default" = warnIfNot hf.hasWireplumber "default-audio module requires wireplumber" {
      text = cfg.default-routes;
      onChange = ''
        cp ~/.local/state/wireplumber/default-routes.hm-default ~/.local/state/wireplumber/default-routes
        chmod 644 ~/.local/state/wireplumber/default-routes
      '';
    };
  };
})
