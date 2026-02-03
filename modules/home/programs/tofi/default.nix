{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  colorscheme = config.custom.home.opts.colorscheme;
in {
  programs.tofi = {
    enable = true;
    package = pkgs.tofi;
    settings = {
      anchor = "top";
      width = "100%";
      height = 20;
      horizontal = true;
      font-size = 8;
      prompt-text = "\"run: \"";
      font = "monospace";
      outline-width = 0;
      border-width = 0;
      background-color = colorscheme.wm.background;
      text-color = colorscheme.wm.text;
      selection-color = colorscheme.wm.foreground-normal;
      min-input-width = 120;
      result-spacing = 15;
      padding-top = 2;
      padding-bottom = 0;
      padding-left = 5; # todo test for all monitors
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

  custom.home.behavior.impermanence.paths = [
    { path = ".local/state/tofi-drun-history"; file = true; }
  ];
})
