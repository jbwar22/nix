{ config, lib, pkgs, inputs, ... }:

with lib; mkNsEnableModule config ./. {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv;
    scripts = [
      inputs.jbwar22-mpv-scripts.packages.${pkgs.system}.downmix
    ];

    config = {
      # screenshot
      screenshot-format = "png";
      screenshot-high-bit-depth = "no";
      # screenshot-png-compression = 8;
      screenshot-directory = "/home/${config.home.username}/pictures/screenshots/mpv";
      screenshot-template = "screenshot-%tY-%tm-%td-%tH:%tM:%tS-%wH:%wM:%wS";
      

      # general behavior
      keep-open = "yes";
      cursor-autohide = 250;


      # OSD
      osd-level = 1;
      osd-fractions = true;

      osd-font = "Noto Sans Mono";
      osd-font-size = 16;
      osd-color = "#CCFFFFFF";
      osd-border-color = "#DD000000";
      osd-border-size = 2;

      osd-bar = "no";
      osd-bar-align-y = 1;
      osd-bar-h = 2;
      osd-bar-w = 60;


      # video processing
      # deband=yes # enabled by default but disabled for 4K videos, below
      # deband-iterations=4 # deband steps
      # deband-threshold=120 # deband strength
      # deband-range=20 # deband range
      # deband-grain=30 # dynamic grain: set to "0" if using the static grain shader
      # hwdec=auto


      # track selection
      # slang=eng
      # alang=jpn
      # subs-fallback = "defualt";


      # subtitles
      demuxer-mkv-subtitle-preroll = "yes";

      sub-auto = "fuzzy";
      sub-file-paths = [
        "ass"
        "sr"
        "sub"
        "subs"
        "subtitles"
        "Eng-Subtitles"
      ];
    };

    profiles = {
      gui = {
        terminal = "no";
        force-window = "yes";
        idle = "once";
      };
    };
  };
}
