{ config, lib, ... }:

with lib; with ns config ./.; (let
  hf = config.custom.home.opts.hostfeatures;
in {
  options = opt {
    default-routes = mkOption {
      type = with types; nullOr lines;
      description = "text";
      default = null;
    };
    default-nodes = mkOption {
      type = with types; nullOr lines;
      description = "text";
      default = null;
    };
  };

  config = {
    home.file.".local/state/wireplumber/default-routes.hm-default" = mkIf (cfg.default-routes != null) (warnIfNot hf.hasWireplumber "default-audio module requires wireplumber" {
      text = ''
        [default-routes]
      '' + cfg.default-routes;
      onChange = ''
        cp ~/.local/state/wireplumber/default-routes.hm-default ~/.local/state/wireplumber/default-routes
        chmod 644 ~/.local/state/wireplumber/default-routes
      '';
    });
    home.file.".local/state/wireplumber/default-nodes.hm-default" = mkIf (cfg.default-nodes != null) (warnIfNot hf.hasWireplumber "default-audio module requires wireplumber" {
      text = ''
        [default-nodes]
      '' + cfg.default-nodes;
      onChange = ''
        cp ~/.local/state/wireplumber/default-nodes.hm-default ~/.local/state/wireplumber/default-nodes
        chmod 644 ~/.local/state/wireplumber/default-nodes
      '';
    });
  };
})
