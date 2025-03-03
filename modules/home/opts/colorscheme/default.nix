{ config, lib, ... }:

with lib;
let
  mkColor = mkOption {
    type = with types; str;
    default = "#00FF00";
  };
  inherit (namespace config { home.opts.colorscheme = ns; }) opt;
in
{
  options = with types; opt {
    terminal = mkOption {
      description = "terminal colors";
      type = (submodule {
        options = {
          foreground = mkColor;
          background = mkColor;

          cursor = mkColor;
          selection-foreground = mkColor;
          selection-background = mkColor;

          color0  = mkColor;
          color1  = mkColor;
          color2  = mkColor;
          color3  = mkColor;
          color4  = mkColor;
          color5  = mkColor;
          color6  = mkColor;
          color7  = mkColor;
          color8  = mkColor;
          color9  = mkColor;
          color10 = mkColor;
          color11 = mkColor;
          color12 = mkColor;
          color13 = mkColor;
          color14 = mkColor;
          color15 = mkColor;
        };
      });
    };
    wm = mkOption {
      description = "wm colors";
      type = (submodule {
        options = {
          background = mkColor;
          text = mkColor;

          foreground-dim = mkColor;
          foreground-normal = mkColor;
          foreground-alert = mkColor;

          foreground-alt-normal = mkColor;

          bg-select-dim = mkColor;
          bg-select-normal = mkColor;
          bg-select-bright = mkColor;
          bg-select-alert = mkColor;

          bg-select-alt-normal = mkColor;
        };
      });
    };
  };
}
