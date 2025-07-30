{ config, lib, pkgs, ... }:

with lib; with ns config ./.; let
  colorscheme = config.custom.home.opts.colorscheme;
  waybar = config.custom.home.programs.waybar;
  swaylock = config.custom.home.programs.swaylock;
  scripts = (import ./scripts) pkgs lib config;
  geolocation = ageOrDefault config "geolocation" "0.00:0.00";
in {
  options = opt {
    enable = mkEnableOption "sway wm";
    blueLightFilter = mkOption {
      type = with types; bool;
      description = "run a blue light filter at night";
      default = true;
    };
    blueLightStrength = mkOption {
      type = with types; int;
      description = "color temperature at night (kelvin)";
      default = 3600;
    };
    shortcuts = mkOption {
      type = with types; let
        t = attrsOf (oneOf [ t package ]);
      in t;
      description = "shortcuts menu";
    };
    brightnessDevice = mkOption {
      type = with types; nullOr str;
      description = "device for brightnessctl";
      default = null;
    };
  };

  config = lib.mkIf cfg.enable (recursiveUpdate (opt {
    shortcuts = import ./shortcuts pkgs lib config;
  }) {
    custom.home.opts.aliases = {
      sway = mkIf config.custom.common.opts.hardware.nvidia "${pkgs.sway}/bin/sway --unsupported-gpu";
      screens = "${pkgs.sway}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | .name + \"\\t\" + .make + \" \" + .model + \" \" + .serial'";
    };

    home.packages = with pkgs; [
      swaybg # background
    ];
    
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "sway";
      NIXOS_OZONE_WL = "1";
    };

    custom.home.behavior.tmpfiles."gammastep-period-output" = mkIf cfg.blueLightFilter {
      type = "f";
      path = "/tmp/sway-gammastep-output-${config.home.username}";
      mode = "1600";
      user = "${config.home.username}";
      group = "users";
      age = "-";
      argument = "none";
    };

    xdg.configFile."gammastep/hooks/log-period.sh".source = mkIf cfg.blueLightFilter (pkgs.writeShellScript "gammastep-log-period-hook" ''
      case $1 in
        period-changed)
          exec echo $3 > ${config.custom.home.behavior.tmpfiles."gammastep-period-output".path}
      esac
    '');

    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.sway;
      # extraOptions = [ "--unsupported-gpu" ];

      systemd.xdgAutostart = true;
      xwayland = true;
      config = rec {
        modifier = "Mod4";
        terminal = "${pkgs.kitty}/bin/kitty";
        menu = "${scripts.menu} -d | xargs ${pkgs.sway}/bin/swaymsg exec --";
        seat = (let 
          cursorTheme = config.custom.home.opts.cursor.theme;
        in {
          "*" = {
            xcursor_theme = "${cursorTheme.name} ${toString cursorTheme.size}";
            hide_cursor = "500";
          };
        });

        input = {
          "type:keyboard" = {
            repeat_delay = "350";
            repeat_rate = "40";
            dwt = "disabled";
          };
          "type:pointer" = {
            accel_profile = "flat";
            dwt = "disabled";
          };
          "type:touchpad" = {
            accel_profile = "adaptive";
            click_method = "clickfinger";
            tap = "enabled";
            natural_scroll = "enabled";
            dwt = "disabled";
          };
          "1:1:AT_Translated_Set_2_keyboard" = {};
          "4809:4809:HID_12c9:1002_Mouse" = {};
          "9610:39:SINOWEALTH_Wired_Gaming_Mouse" = {};
          "1739:0:Synaptics_TM3276-022" = {
            scroll_factor = "0.5";
          };
          "1133:49291:Logitech_G502_HERO_Gaming_Mouse" = {
            pointer_accel = "-0.5";
            scroll_factor = "0.5";
          };
          "12375:3:PIXART_VAXEE_Wireless_Mouse" = {
            pointer_accel = "0";
            scroll_factor = "0.7";
          };
          "12375:2:PIXART_VAXEE_Mouse" = {
            pointer_accel = "0";
            scroll_factor = "0.7";
          };
          "2362:628:PIXA3854:00_093A:0274_Touchpad" = { # framework touchpad
            scroll_factor = "0.5";
          };
        };

        output = foldl' (accum: screen: accum // (let
          screen-def = screen.value.sway;
        in {
          "${screen.name}" = screen-def; # don't mkIf this one! some options don't work otherwise!
          "${screen.name} Unknown" = mkIf screen.value.noserial screen-def;
        })) {
          "*" = {
            bg = "${config.custom.home.opts.wallpaper} fill";
          };
        } (attrsToList config.custom.home.opts.screens);

        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
          alt = "Mod1";
          shortcuts-launcher = import ./shortcuts/launcher.nix pkgs lib config scripts.menu;
        in lib.mkOptionDefault { # append to default behavior

          # Media keys: Audio
          "XF86AudioRaiseVolume" = "exec ${scripts.volume} up";
          "XF86AudioLowerVolume" = "exec ${scripts.volume} down";
          "XF86AudioMute" = "exec ${scripts.volume} mute";
          "XF86AudioMicMute" = "exec ${scripts.volume} micmute";

          # Media keys: Display
          "XF86MonBrightnessUp" = mkIf (cfg.brightnessDevice != null) "exec ${scripts.brightness} up";
          "XF86MonBrightnessDown" = mkIf (cfg.brightnessDevice != null) "exec ${scripts.brightness} down";
          "XF86Display" = mkIf cfg.blueLightFilter "exec pkill -USR1 gammastep";
          "XF86Favorites" = mkIf swaylock.enable "exec ${pkgs.swaylock}/bin/swaylock & systemctl suspend";
          "${modifier}+Shift+delete" = mkIf swaylock.enable "exec ${pkgs.swaylock}/bin/swaylock";

          # Screenshot
          "${modifier}+Shift+s" = "exec ${scripts.screenshot}";
          "${modifier}+Shift+t" = "exec ${scripts.screenshot} -c";
          "${modifier}+${alt}+Shift+s" = "exec ${scripts.screenshot} -f";
          "${modifier}+${alt}+Shift+t" = "exec ${scripts.screenshot} -cf";

          # Workspace output moving
          "${modifier}+greater" = "move workspace to output right";
          "${modifier}+less" = "move workspace to output left";
          "${modifier}+${alt}+greater" = "move workspace to output up";
          "${modifier}+${alt}+less" = "move workspace to output down";

          # Shortcut
          "${modifier}+s" = "exec ${shortcuts-launcher}";

          # nix run
          "${modifier}+x" = "exec ${scripts.runner}";

          # Remap defaults
          "${modifier}+${alt}+space" = "focus mode_toggle";
          "${modifier}+${alt}+s" = "layout stacking";

          # Basic behavior
          "${modifier}+Shift+a" = "focus child";

          # Disable defaults
          "${modifier}+space" = null;
          "${modifier}+Up" = null;
          "${modifier}+Down" = null;
          "${modifier}+Left" = null;
          "${modifier}+Right" = null;
          "${modifier}+Shift+Up" = null;
          "${modifier}+Shift+Down" = null;
          "${modifier}+Shift+Left" = null;
          "${modifier}+Shift+Right" = null;
        };
        bars = [{
          "command" = mkIf waybar.enable "${pkgs.waybar}/bin/waybar";
        }];
        colors = rec {
          background = colorscheme.wm.background;
          focused = {
            inherit background;
            border = colorscheme.wm.foreground-normal;
            childBorder = colorscheme.wm.foreground-normal;
            indicator = colorscheme.wm.foreground-normal;
            text = colorscheme.wm.text;
          };
          unfocused = {
            inherit background;
            border = colorscheme.wm.foreground-dim;
            childBorder = colorscheme.wm.foreground-dim;
            indicator = colorscheme.wm.foreground-dim;
            text = colorscheme.wm.text;
          };
          urgent = {
            inherit background;
            border = colorscheme.wm.foreground-alert;
            childBorder = colorscheme.wm.foreground-alert;
            indicator = colorscheme.wm.foreground-alert;
            text = colorscheme.wm.text;
          };
          focusedInactive = unfocused;
          placeholder = unfocused;
        };
        gaps = {
          inner = 4;
          outer = -4;
        };
        window = {
          border = 2;
          hideEdgeBorders = "smart";
          titlebar = false;
          commands = [{
            criteria.window_role = "pop-up";
            command = "floating enable";  
          } {
            criteria.window_role = "task_dialog";
            command = "floating enable";
          } {
            criteria.title = "Firefox - Choose User Profile";
            criteria.app_id = "firefox";
            command = "floating enable";
          } {
            criteria.title = "LibreWolf - Choose User Profile";
            criteria.app_id = "librewolf";
            command = "floating enable";
          } {
            criteria.title = "Save As";
            criteria.app_id = "librewolf";
            command = "resize set height 600";
          } {
            criteria.title = "Save As";
            criteria.app_id = "librewolf";
            command = "resize set width 1200";
          } {
            criteria.title = "Extension: (Bitwarden Password Manager) - Bitwarden — LibreWolf";
            command = "floating enable";
          }];
        };
        floating = {
          border = 2;
        };
        startup = [
          # TODO these are really not consistant
          # {
          #   # swayidle is handling lock-before-sleep instead
          #   command = "pkill xss-lock; ${pkgs.xss-lock}/bin/xss-lock --ignore-sleep ${pkgs.swaylock}/bin/swaylock --ring-color=\"#000044\"";
          #   always = true;
          # }
          {
            command = "pkill dunst; ${pkgs.dunst}/bin/dunst";
            always = true;
          }
          (mkIf cfg.blueLightFilter {
            command = "pkill -9 gammastep; ${pkgs.gammastep}/bin/gammastep -l $(cat ${geolocation}) -t 6500:${toString cfg.blueLightStrength}";
            always = true;
          })
        ];
      };
      extraConfig = ''
        titlebar_padding 4 1
        font pango:monospace 7.71

        bindgesture swipe:4:left workspace prev
        bindgesture swipe:4:right workspace next
        bindgesture swipe:3:right focus right
        bindgesture swipe:3:left focus left
        bindgesture swipe:3:up focus up
        bindgesture swipe:3:down focus down
        bindgesture pinch:4:inward+right move container to workspace next
        bindgesture pinch:4:inward+left move container to workspace prev

        set $PROP none
        for_window [shell="."] mark --add "prop:$$PROP:"
        for_window [con_mark=^prop.*:floating:] floating enable
        for_window [con_mark=^prop.*:fullscreen:] fullscreen enable
        for_window [con_mark=^prop.*:shellpopup:] floating enable ; resize set width 1000 ; resize set height 55
        for_window [con_mark=^prop:] mark --toggle "prop:$$PROP:" ; set $$PROP none
      '' + (pipe config.custom.home.opts.screens [
        attrsToList
        (map (x: if x.value.clamshell then (let
          name = if x.value.noserial then x.name + " Unknown" else x.name;
        in ''
          # bindswitch --reload --locked lid:on output "${name}" disable
          # bindswitch --reload --locked lid:off output "${name}" enable
          # bindsym --locked XF86AudioMedia output ${name} enable
        '') else ""))
        (concatStringsSep "\n")
      ]);
    };
  });
}
