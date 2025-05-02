let
  foreground = "#FFFFFF";
  background = "#000000";

  red        = "#a54242";
  red-ds1    = "#cc6666";
  green      = "#8c9440";
  green-ds1  = "#b5bd68";
  orange     = "#de935f";
  orange-ds1 = "#f0c674";
  blue       = "#5f819d";
  blue-ds1   = "#81a2be";
  purple     = "#85678f";
  purple-ds1 = "#b294bb";
  cyan       = "#5e8d87";
  cyan-ds1   = "#8abeb7";

  gray-d1 = "#333333";
  gray-b1 = "#CCCCCC";

  f-orange    = "#FB5000";
  f-orange-d3 = "#993300";
  f-orange-d4 = "#772200";
  f-orange-d5 = "#441100";

  orange-ds3 = "#FFCC99";

in {
  terminal = rec {
    inherit foreground background;

    cursor = foreground;
    selection-foreground = background;
    selection-background = foreground;

    color0  = background;
    color1  = red;
    color2  = green;
    color3  = orange;
    color4  = blue;
    color5  = purple;
    color6  = cyan;
    color7  = gray-b1;
    color8  = gray-d1;
    color9  = red-ds1;
    color10 = green-ds1;
    color11 = orange-ds1;
    color12 = blue-ds1;
    color13 = purple-ds1;
    color14 = cyan-ds1;
    color15 = foreground;
  };

  wm = rec {
    inherit background;
    text = foreground;

    foreground-dim = f-orange-d4;
    foreground-normal = f-orange;
    foreground-alert = orange-ds3;

    foreground-alt-normal = foreground;

    bg-select-dim = f-orange-d5;
    bg-select-normal = f-orange-d4;
    bg-select-bright = f-orange-d3;
    bg-select-alert = orange-ds3;

    bg-select-alt-normal = gray-b1;
  };
}
