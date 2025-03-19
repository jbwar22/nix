{ config, lib, ... }:

with lib; mkNsEnableModule config ./. (let
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
})
