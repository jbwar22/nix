{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.logind.settings.Login = {
    HandlePowerKey = "lock";
    HandlePowerKeyLongPress = "poweroff";
  };
}
