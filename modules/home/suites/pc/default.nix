{ ns, ... }:

ns.enable {
  custom.home = {
    programs = {
      arduino.enable = true;
      keyring.enable = true;
      ente-auth.enable = true;
    };
  };
}
