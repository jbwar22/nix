pkgs: config: select-area:

pkgs.writeShellScript "sway-screenshot" ''
  copyonly=false
  fullscreen=false

  while getopts ":cf" opt; do
    case $opt in
      c)
        copyonly=true
        ;;
      f)
        fullscreen=true
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
  done

  home=${config.home.homeDirectory}
  scrdir=$home/pictures/screenshots/grim

  if [ $fullscreen = true ]; then
    area="$(${pkgs.slurp}/bin/slurp -o)"
  else
    area="$(${select-area})"
  fi

  if [ $copyonly = true ]; then
    outputfile="/dev/null"
  else
    outputfile="$(${pkgs.coreutils}/bin/date +$scrdir/screenshot-%Y-%m-%d-%H:%M:%S.png)"
  fi

  ${pkgs.grim}/bin/grim -g "$area" - | \
      tee \
          >(${pkgs.wl-clipboard}/bin/wl-copy -t image/png) \
          $outputfile \
          > /dev/null
''
