{ config, lib, pkgs, ... }:

with lib; with namespace config { home.programs.dunst = ns; }; let
  colorscheme = config.custom.home.opts.colorscheme;
in {
  options = opt {
    enable = mkEnableOption "dunst notification manager";
  };

  config = lib.mkIf cfg.enable {

    services.dunst = {

      # PAUSE LEVELS:
      # 0 : default
      # 50: my default pause level (set in waybar module)
      # 90: system critical notifications

      enable = true;
      package = pkgs.dunst;
      settings = {
        global = {
          # display options
          follow = "mouse";

          # visual
          width = 300;
          origin = "top-right";
          offset = "6x6";
          scale = 0;
          padding = 8;
          horizontal_padding = 8;
          text_icon_padding = 0;
          frame_width = 2;
          gap_size = 4;
          transparency = 0;
          icon_corner_radius = 0;
          markup = "full";
          format = "<b>%s</b>\\n%b";
          show_age_threshold = 60;
          min_icon_size = 32;
          max_icon_size = 32;

          # color
          frame_color = colorscheme.wm.foreground-normal;
          background = colorscheme.wm.background;
          foreground = colorscheme.wm.text;

          # behavior
          notification_limit = 10;
          indicate_hidden = true;
          sort = "yes";
          dmenu = "tofi --prompt=\"dunst: \"";

          # progress
          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 2;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;
          progress_bar_corner_radius = 0;

          # trigger update of waybar module
          script = "${pkgs.writeShellScript "waybar-dunst-signal" ''
            pkill -RTMIN+5 waybar
          ''}";
        };
        urgency_low = {
          timeout = 10;
        };
        urgency_normal = {
          timeout = 10;
        };
        urgency_critical = {
          timeout = 0;
        };
        mediakeys = {
          appname = "mediakeys";
          alignment = "center";
          override_pause_level = 90;
        };
        discord = {
          appname = "discord";
          summary = "*";
          script = "${pkgs.writeShellScript "dunst-discord" ''
            ${pkgs.sway}/bin/swaymsg [class="discord"] urgent enable
          ''}";
        };
        slack = {
          appname = "Slack";
          summary = "*";
          override_pause_level = 70;
        };
      };
    };

  };
}
