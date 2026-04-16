{ ns, ... }:

ns.enable {
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
  };
}
