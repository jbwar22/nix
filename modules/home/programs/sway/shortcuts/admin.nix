pkgs: lib: config:

let
  inherit (lib)
  mkIf;
  inherit (pkgs)
  sway-kitty-popup-admin;

  hf = config.custom.home.opts.hostfeatures;
in {
  firewall = mkIf hf.usesNixosFirewall {
    reset = sway-kitty-popup-admin "shortcuts-admin-firewall-reset" ''
      sudo nixos-firewall-tool reset
    '';

    snapweb = mkIf hf.runningSnapweb (
      sway-kitty-popup-admin "shortcuts-admin-firewall-snapweb" ''
        sudo nixos-firewall-tool open tcp 1780
      ''
    );
  };

  cpupower = mkIf hf.hasCpupower {
    performance = sway-kitty-popup-admin "shortcuts-admin-cpupower-performance" ''
      sudo cpupower frequency-set -g performance
    '';
    powersave = sway-kitty-popup-admin "shortcuts-admin-cpupower-performance" ''
      sudo cpupower frequency-set -g powersave
    '';
  };

  tailscale = mkIf hf.hasTailscale {
    up = sway-kitty-popup-admin "shortcuts-admin-tailscale-up" ''
      sudo tailscale up
    '';
    down = sway-kitty-popup-admin "shortcuts-admin-tailscale-down" ''
      sudo tailscale down
    '';
  };
}
