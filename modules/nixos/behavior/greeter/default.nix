{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
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
