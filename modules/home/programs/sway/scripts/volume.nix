pkgs: slider:
pkgs.writeShellScript "sway-volume" ''
  current=$(${pkgs.pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | \
            head -1 | \
            grep -Po '[0-9]{1,3}(?=%)' | \
            head -1)

  if [[ $1 == "mute" ]]; then
      ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle
      newp="$(${slider} query $current \
              0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100)"
  elif [[ $1 == "micmute" ]]; then
    ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle
    exit $?
  else
      newp="$(${slider} $1 $current \
              0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100)"
  fi

  newp2=($newp)
  new=''${newp2[0]}
  per=''${newp2[1]}
  num=''${newp2[2]}
  max=''${newp2[3]}

  mute=$(${pkgs.pulseaudio}/bin/pactl get-sink-mute @DEFAULT_SINK@ | \
         head -1 | \
         grep -Po '(?<=Mute: )(yes|no)')
  if [ "$new" != "$current" ] ; then
      ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ ''${new}%
  fi

  mutestr=""
  if [[ "$mute" = "yes" ]]; then
      mutestr=" (MUTED)"
  fi

  ${pkgs.dunst}/bin/dunstify -a mediakeys -t 1000 -r 100 -u normal \
  -h int:value:$per -h string:hlcolor:#660000 Volume:\ "$per%$mutestr"
''
