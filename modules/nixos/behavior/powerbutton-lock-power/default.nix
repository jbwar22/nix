{ ns, ... }:

ns.enable {
  services.logind.settings.Login = {
    HandlePowerKey = "lock";
    HandlePowerKeyLongPress = "poweroff";
  };
}
