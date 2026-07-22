{ ns, ... }:

ns.enable {
  services.kdeconnect = {
    enable = true;
  };

  custom.home.behavior.impermanence.paths = [ ".config/kdeconnect" ];
}
