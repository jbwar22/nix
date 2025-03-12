{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "options reactive based on home-manager options for all hosts";
  };

  config = mkIf cfg.enable {
    custom.nixos = {
      programs.home = {
        swaylock.enable = mkIfAnyHMOpt config (config: config.programs.swaylock.enable) true;
        fcitx5.enable = mkIfAnyHMOpt config (config: config.custom.home.programs.fcitx5.enable) true;
      };

      behavior = {
        xdg-screenshare.enable = mkIfAnyHMOpt config (config: config.wayland.windowManager.sway.enable) true;
      };
    };
  };
}
