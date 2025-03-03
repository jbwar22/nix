pkgs: select-area:

pkgs.writeShellScript "sway-copyscreen" ''
  area="$(${select-area})"
  ${pkgs.grim}/bin/grim -g "$area" - | wl-copy -t image/png
''
