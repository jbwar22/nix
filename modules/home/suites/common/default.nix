{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
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
      atuin.enable = true;
      bash.enable = true;
      blueman.enable = true;
      chromium.enable = true;
      direnv.enable = true;
      discord.enable = true;
      fastfetch.enable = true;
      firefox.enable = true;
      git.enable = true;
      gpg-agent.enable = true;
      houdoku.enable = true;
      kitty.enable = true;
      librewolf.enable = true;
      mpv.enable = true;
      neofetch.enable = true;
      nixvim.enable = true;
      ranger.enable = true;
      signal.enable = true;
      sqlitebrowser.enable = true;
      tmux.enable = true;
      udiskie.enable = true;
      vim.enable = true;
    };
  };
}
