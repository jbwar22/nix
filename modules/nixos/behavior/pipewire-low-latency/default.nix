{ ns, ... }:

ns.enable {
  # from nix-gaming
  services.pipewire.lowLatency.enable = true;
  services.pipewire.lowLatency.quantum = 64;
}
