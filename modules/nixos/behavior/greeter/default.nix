{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${pkgs.sway}/share/wayland-sessions --remember --remember-user-session";
        user = "greeter";
      };
    };
  };
}
