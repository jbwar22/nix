final: prev: rec {
  sway-kitty-popup = name: body: prev.writeShellScript "sway-kitty-popup-outer-${name}" ''
    ${final.sway}/bin/swaymsg 'set $PROP shellpopup; exec ${final.kitty}/bin/kitty -e ${
      final.writeShellScript "sway-kitty-popup-inner-${name}" body
    }'
  '';
  sway-kitty-popup-admin = name: command: sway-kitty-popup name ''
    echo executing: ${final.lib.trim command}
    ${final.lib.trim command}
    if [ $? -eq 0 ]; then
      echo
      echo success
    else
      echo
      echo failure
    fi
    sleep 1
  '';
}
