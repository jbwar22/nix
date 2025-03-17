pkgs: lib: config:

{
  reset = pkgs.writeShellScript "shortcuts-firewall-reset" ''
    ${pkgs.sway}/bin/swaymsg 'set $PROP shellpopup; exec ${pkgs.kitty}/bin/kitty -e ${
      pkgs.writeShellScript "shortcuts-firewall-reset-inner" ''
        echo executing: sudo nixos-firewall-tool reset
        sudo nixos-firewall-tool reset
      ''
    }'
  '';
}
