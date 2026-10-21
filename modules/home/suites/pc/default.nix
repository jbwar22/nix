{ ns, ... }:

ns.enable {
  custom.home = {
    programs = {
      noconfig.gui.enable = true;
      arduino.enable = true;
      keyring.enable = true;
      ente-auth.enable = true;
    };
  };
}
