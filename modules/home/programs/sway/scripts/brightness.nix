# visually set
# scale="1 10 25 45 70 105 150 200 265 330 420 530 655 800 940 1100 1300 1515"

# fit to ax^2 + 1: 0,1 18,1515, then add a 0 at beginning
# scale="0 1 6 22 48 85 132 190 258 336 425 525 635 755 886 1028 1179 1342 1515"

# fit: 0,0 1,1 18,1515
# scale="0 1 12 32 63 103 153 212 282 361 450 549 658 776 904 1042 1190 1348 1515"

# fit: 0,0 1,1 20,1515

pkgs: slider:
pkgs.writeShellScript "sway-brightness" ''
  current=$(${pkgs.brightnessctl}/bin/brightnessctl \
            --device="intel_backlight" | \
            head -2 | \
            tail -1 | \
            awk '{ print $3 }')
  newp="$(${slider} $1 $current \
          0 1 10 27 51 84 124 172 228 292 364 \
          444 531 627 730 841 960 1087 1222 1365 1515)"
  newp2=($newp)
  new=''${newp2[0]}
  per=''${newp2[1]}
  num=''${newp2[2]}
  max=''${newp2[3]}
  if [ "$new" != "$current" ] ; then
      ${pkgs.brightnessctl}/bin/brightnessctl \
      --device="intel_backlight" set $new
  fi
  ${pkgs.dunst}/bin/dunstify -a mediakeys -t 1000 -r 100 -u normal \
  -h int:value:$per -h string:hlcolor:#660000 Brightness:\ $num/$max
''
