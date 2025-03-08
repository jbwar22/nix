{ pkgs, config, lib, ... }:

with lib; with namespace config { home.behavior.fonts = ns; }; {
  options = opt {
    enable = mkEnableOption "the basic suite of home modules (for all hosts)";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      freefont_ttf
      corefonts
      vistafonts
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

  };
}
