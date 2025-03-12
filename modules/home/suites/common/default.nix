{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "the basic suite of home modules (for all hosts)";
  };

  config = lib.mkIf cfg.enable {

    custom.home = {
      behavior = {
        cursor-settings.enable = true;
        environment.enable = true;
        fonts.enable = true;
        xdg.enable = true;
      };

      programs = {
        noconfig.gui.enable = true;
        noconfig.tui.enable = true;
        noconfig.util.enable = true;
        bash.enable = true;
        blueman.enable = true;
        direnv.enable = true;
        discord.enable = true;
        fastfetch.enable = true;
        firefox.enable = true;
        kitty.enable = true;
        librewolf.enable = true;
        mpv.enable = true;
        neofetch.enable = true;
        ranger.enable = true;
        tmux.enable = true;
        udiskie.enable = true;
      };
    };
  };
}
