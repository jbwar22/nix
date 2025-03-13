pkgs:

{
  discord = pkgs.writeShellScript "shortcuts-screens-vert" ''
    ${pkgs.procps}/bin/pkill -9 Discord
  '';
}
