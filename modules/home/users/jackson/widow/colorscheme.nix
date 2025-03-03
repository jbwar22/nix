let
  foreground = "#FFFFFF";
  background = "#000000";

  red-d5 = "#190000";
  red-d4 = "#330000";
  red-d3 = "#4C0000";
  red-d2 = "#990000";
  red-d1 = "#CC0000";
  red    = "#FF0000";
  red-b1 = "#FF3333";
  red-b2 = "#FF6666";
  red-b3 = "#FF9999";

  red-ds1-d2 = "#993333";
  red-ds2 = "#FF5555";

  gray = "#555555";


in {
  terminal = rec {
    inherit foreground background;

    cursor = foreground;
    selection-foreground = background;
    selection-background = foreground;

    color0  = background;
    color1  = red-d2;
    color2  = red-d1;
    color3  = red;
    color4  = red-b1;
    color5  = red-b2;
    color6  = red-b3;
    color7  = foreground;
    color8  = gray;
    color9  = red-d2;
    color10 = red-d1;
    color11 = red;
    color12 = red-b1;
    color13 = red-b2;
    color14 = red-b3;
    color15 = foreground;
  };

  wm = rec {
    inherit background;
    text = foreground;

    foreground-dim = red-d4;
    foreground-normal = red-d1;
    foreground-alert = red-ds2;

    foreground-alt-normal = foreground;

    bg-select-dim = red-d5;
    bg-select-normal = red-d4;
    bg-select-bright = red-d3;
    bg-select-alert = red-ds1-d2;

    bg-select-alt-normal = gray;
  };
}
