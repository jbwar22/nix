{ pkgs, config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    freefont_ttf
    corefonts
    vista-fonts
  ];

  fonts.fontconfig = {
    enable = true;
    
    defaultFonts = {
      serif = [ "Noto Serif" "Noto Serif CJK JP" ];
      sansSerif = [ "Noto Sans" "Noto Sans CJK JP" ];
      monospace = [ "Noto Sans Mono" "Noto Sans Mono CJK JP" ];
    };
  };

  xdg.configFile."fontconfig/conf.d/53-helvetica.conf".source = ./helvetica.conf;

  custom.home.behavior.impermanence.dirs = [ ".cache/fontconfig" ];
}
