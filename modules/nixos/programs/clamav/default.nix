{ ns, ... }:

ns.enable {
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };
}
