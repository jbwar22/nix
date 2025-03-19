{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  colorscheme = config.custom.home.opts.colorscheme;
in {
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;

    font = {
      name = "DejaVu Sans Mono";
      package = pkgs.dejavu_fonts;
      # size = 12; # monstro
      size = 9.9;
    };
    settings = {
      wayland_enable_ime = "yes"; # req version>=0.35.0

      # usage
      enable_audio_bell = "no";

      # visual
      active_table_font_style = "normal";
      placement_strategy = "bottom-left";

      # colors

      inherit (colorscheme.terminal)
      foreground
      background
      cursor
      selection-foreground
      selection-background

      color0
      color1
      color2
      color3
      color4
      color5
      color6
      color7
      color8
      color9
      color10
      color11
      color12
      color13
      color14
      color15;
    };
  };
})
