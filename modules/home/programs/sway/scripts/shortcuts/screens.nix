pkgs: lib: config:

{
  vert = pkgs.writeShellScript "shortcuts-screens-vert" ''
    ${pkgs.sway}/bin/swaymsg 'output "ASUSTek COMPUTER INC VG27AQL1A S1LMQS102258" transform 90'
  '';
}
