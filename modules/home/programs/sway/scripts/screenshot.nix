pkgs: config: select-area:

pkgs.writeShellScript "sway-screenshot" ''
  area="$(${select-area})"
  home=${config.home.homeDirectory}
  scrdir=$home/pictures/screenshots/grim
  ${pkgs.grim}/bin/grim -g "$area" - | \
      tee \
          >(${pkgs.wl-clipboard}/bin/wl-copy -t image/png) \
          $(date +$scrdir/screenshot-%Y-%m-%d-%H:%M:%S.png) \
          > /dev/null
''
