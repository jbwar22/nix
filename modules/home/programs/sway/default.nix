{ config, lib, pkgs, ... }:

with lib; with namespace config { home.programs.sway = ns; }; let
  colorscheme = config.custom.home.opts.colorscheme;
  waybar = config.custom.home.programs.waybar;
  swaylock = config.custom.home.programs.swaylock;
  scripts = (import ./scripts) pkgs lib config;

  geolocation = ageOrDefault config "geolocation" "0.00:0.00";
in {
  options = opt {
    enable = mkEnableOption "sway wm";
    blueLightFilter = with types; mkOption {
      type = bool;
      description = "run a blue light filter at night";
      default = true;
    };
    blueLightStrength = with types; mkOption {
      type = int;
      description = "color temperature at night (kelvin)";
      default = 3600;
    };
  };

  config = lib.mkIf cfg.enable {
    custom.home.opts.aliases = {
      sway = mkIf config.custom.common.opts.hardware.nvidia "${pkgs.sway}/bin/sway --unsupported-gpu";
      getgeo = "echo ${geolocation}";
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
        menu = "${scripts.menu} | xargs ${pkgs.sway}/bin/swaymsg exec --";
        seat = (let 
          cursorTheme = config.custom.home.opts.cursor.theme;
        in {
          "*" = {
            xcursor_theme = "${cursorTheme.name} ${toString cursorTheme.size}";
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
        };

        output = foldl' (accum: screen: accum // (let
          screen-def = {
            inherit (screen) resolution position;
            adaptive_sync = mkIf screen.vrr "on";
            bg = "${screen.wallpaper.path} ${screen.wallpaper.mode}";
          };
        in {
          "${screen.name}" = screen-def;
          "${screen.name} Unknown" = mkIf screen.noserial screen-def;
        })) {
          "*" = {
            bg = "${config.custom.home.opts.wallpaper.path} fill";
          };
        } config.custom.home.opts.screens.config;

        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
          alt = "Mod1";
        in lib.mkOptionDefault { # append to default behavior

          # Media keys: Audio
          "XF86AudioRaiseVolume" = "exec ${scripts.volume} up";
          "XF86AudioLowerVolume" = "exec ${scripts.volume} down";
          "XF86AudioMute" = "exec ${scripts.volume} mute";
          "XF86AudioMicMute" = "exec ${scripts.volume} micmute";

          # Media keys: Display
          "XF86MonBrightnessUp" = "exec ${scripts.brightness} up";
          "XF86MonBrightnessDown" = "exec ${scripts.brightness} down";
          "XF86Display" = mkIf cfg.blueLightFilter "exec pkill -USR1 gammastep";
          "XF86Favorites" = mkIf swaylock.enable "exec ${pkgs.swaylock}/bin/swaylock & systemctl suspend";
          "${modifier}+Shift+delete" = mkIf swaylock.enable "exec ${pkgs.swaylock}/bin/swaylock";


          "${modifier}+Shift+s" = "exec ${scripts.screenshot}";
          "${modifier}+Shift+t" = "exec ${scripts.screenshot} -c";
          "${modifier}+${alt}+Shift+s" = "exec ${scripts.screenshot} -f";
          "${modifier}+${alt}+Shift+t" = "exec ${scripts.screenshot} -cf";

      "${modifier}+greater" = "move workspace to output right";
      "${modifier}+less" = "move workspace to output left";
      "${modifier}+${alt}+greater" = "move workspace to output up";
      "${modifier}+${alt}+less" = "move workspace to output down";

          # TODO gesture bindings
          # TODO bookmarks

          # Additional basic
          # TODO floating terminal

          # Override
           "${modifier}+${alt}+space" = "focus mode_toggle";
           "${modifier}+space" = null;
          
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
      '';
    };
  };
}
