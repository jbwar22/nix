{ ns, config, lib, clib, ... }:

let
  inherit (lib)
  mkForce;
  inherit (clib)
  ageOrBust;
  geolocation = ageOrBust config "geolocation";
in ns.enable {
  services.geoclue2 = {
    enable = true;
    enable3G = false;
    enableCDMA = false;
    enableNmea = false;
    enableWifi = false;
    enableModemGPS = false;
    enableStatic = true;
    staticLatitude = 0;
    staticLongitude = 0;
    staticAltitude = 0;
    staticAccuracy = 100;
  };

  environment.etc."geolocation" = {
    source = geolocation;
    text = mkForce null;
  };
}
