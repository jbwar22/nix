{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "tofi";
  };

  config = lib.mkIf cfg.enable {
    programs.tofi = {
      enable = true;
      package = pkgs.tofi;
      settings = {
        anchor = "top";
        width = "100%";
        height = 20;
        horizontal = true;
        font-size = 8;
        prompt-text = "\" run: \"";
        font = "monospace";
        outline-width = 0;
        border-width = 0;
        background-color = "#000000";
        selection-color = "#FFFFFF";
        min-input-width = 120;
        result-spacing = 15;
        padding-top = 2;
        padding-bottom = 0;
        padding-left = 0;
        padding-right = 0;
      };
    };

    home.activation = {
      # https://github.com/philj56/tofi/issues/115#issuecomment-1950273960
      regenerateTofiCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        tofi_cache=${config.xdg.cacheHome}/tofi-drun
        [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
      '';
    };
  };
}
