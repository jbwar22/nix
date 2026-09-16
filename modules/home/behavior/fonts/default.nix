{ pkgs, ns, ... }:

ns.enable {
  home.packages = [
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.noto-fonts-color-emoji
    pkgs.freefont_ttf
    pkgs.corefonts
    pkgs.vista-fonts
    pkgs.jigmo
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

  custom.home.behavior.impermanence.paths= [ { path = ".cache/fontconfig"; origin = "local"; } ];
}
