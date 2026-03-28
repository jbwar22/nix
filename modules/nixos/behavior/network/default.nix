{ ns, ... }:

ns.enable {
  networking.networkmanager.enable = true;

  custom.nixos.behavior.impermanence.paths = [ "/etc/NetworkManager/system-connections" ];
}
