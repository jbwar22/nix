pkgs: lib: config:

{
  reset = pkgs.sway-kitty-popup "shortcuts-firewall-reset" ''
    echo executing: sudo nixos-firewall-tool reset
    sudo nixos-firewall-tool reset
  '';
}
