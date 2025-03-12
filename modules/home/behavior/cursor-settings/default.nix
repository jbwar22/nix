{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "stuff to actually set when you set the cursor";
  };

  config = lib.mkIf cfg.enable (let
    cursorTheme = config.custom.home.opts.cursor.theme;
  in {

    gtk = {
      enable = true;
      inherit cursorTheme;
    };

    home.pointerCursor = cursorTheme // {
      gtk.enable = true;
    };

    home.sessionVariables = {
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = toString cursorTheme.size;
    };

  });
}
