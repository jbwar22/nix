{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.logind = {
    powerKey = "lock";
    powerKeyLongPress = "poweroff";
  };
}
