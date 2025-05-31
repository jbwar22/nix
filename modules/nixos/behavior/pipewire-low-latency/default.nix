{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  # from nix-gaming
  services.pipewire.lowLatency.enable = true;
  services.pipewire.lowLatency.quantum = 48;
}
