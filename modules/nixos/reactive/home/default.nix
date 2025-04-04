{ config, lib, ... }:

with lib; mkNsEnableModule config ./. (let
  users = config.custom.common.opts.host.users;
in {
  custom.nixos = {
    programs.home = {
      swaylock.enable = mkIfAnyHMOpt config (config: config.programs.swaylock.enable) true;
      fcitx5.enable = mkIfAnyHMOpt config (config: config.custom.home.programs.fcitx5.enable) true;
    };

    behavior = {
      xdg-screenshare.enable = mkIfAnyHMOpt config (config: config.wayland.windowManager.sway.enable) true;
      shairport-support = mkIfAnyHMOpt config (config: config.custom.home.services.shairport.enable) {
        enable = true;
        ports = pipe users [
          (getHMOpt config (config:
            if config.custom.home.services.shairport.enable then (
              config.custom.home.services.shairport.port
            ) else null
          ))
          (filter (x: x != null))
        ];
      };
    };
  };
})
