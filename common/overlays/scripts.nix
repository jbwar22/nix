final: prev: {
  sway-kitty-popup = name: body: prev.writeShellScript "sway-kitty-popup-outer-${name}" ''
    ${final.sway}/bin/swaymsg 'set $PROP shellpopup; exec ${final.kitty}/bin/kitty -e ${
      final.writeShellScript "sway-kitty-popup-inner-${name}" body
    }'
  '';
}
