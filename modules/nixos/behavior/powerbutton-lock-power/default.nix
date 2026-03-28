{ config, lib, ns, ... }:

with lib; ns.enable {
  services.logind.settings.Login = {
    HandlePowerKey = "lock";
    HandlePowerKeyLongPress = "poweroff";
  };
}
