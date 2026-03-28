{ ns, ... }:

ns.enable {
  services.gpg-agent = {
    enable = true;
  };

  custom.home.behavior.impermanence.paths = [ ".gnupg" ];
}
