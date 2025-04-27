pkgs: lib: config:

with lib; (let
  hf = config.custom.home.opts.hostfeatures;
in {
  firewall = mkIf hf.usesNixosFirewall {
    reset = pkgs.sway-kitty-popup-admin "shortcuts-admin-firewall-reset" ''
      sudo nixos-firewall-tool reset
    '';

    snapweb = mkIf hf.runningSnapweb (
      pkgs.sway-kitty-popup-admin "shortcuts-admin-firewall-snapweb" ''
        sudo nixos-firewall-tool open tcp 1780
      ''
    );
  };

  cpupower = mkIf hf.hasCpupower {
    performance = pkgs.sway-kitty-popup-admin "shortcuts-admin-cpupower-performance" ''
      sudo cpupower frequency-set -g performance
    '';
    powersave = pkgs.sway-kitty-popup-admin "shortcuts-admin-cpupower-performance" ''
      sudo cpupower frequency-set -g powersave
    '';
  };

  tailscale = mkIf hf.hasTailscale {
    up = pkgs.sway-kitty-popup-admin "shortcuts-admin-tailscale-up" ''
      sudo tailscale up
    '';
    down = pkgs.sway-kitty-popup-admin "shortcuts-admin-tailscale-down" ''
      sudo tailscale down
    '';
  };
})
