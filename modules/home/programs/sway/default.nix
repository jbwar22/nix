{ config, lib, clib, pkgs, ns, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt
  opt;
  inherit (lib)
  attrsToList
  concatLines
  concatStringsSep
  foldl'
  mkForce
  mkIf
  mkMerge
  mkOption
  pipe;
  inherit (lib.types)
  attrsOf
  bool
  int
  nullOr
  oneOf
  package
  str;
  inherit (clib)
  ageOrDefault
  enums
  mkIfElse;
  inherit (pkgs)
  brightnessctl
  coreutils
  dunst
  gammastep
  jq
  kitty
  procps
  quickshell
  sway
  swaylock
  waybar
  writeShellScript
  writeShellScriptBin
  xscreensaver;
in {
  options = eopt {
    blueLightFilter = mkOption {
      type = bool;
      description = "run a blue light filter at night";
      default = true;
    };
    blueLightStrength = mkOption {
      type = int;
      description = "color temperature at night (kelvin)";
      default = 3600;
    };
    shortcuts = mkOption {
      type = let
        t = attrsOf (oneOf [ t package ]);
      in t;
      description = "shortcuts menu";
    };
    brightnessDevice = mkOption {
      type = nullOr str;
      description = "device for brightnessctl";
      default = null;
    };
  };

  config = ecfg (let
    colorschemecfg = config.custom.home.opts.colorscheme;
    waybarcfg = config.custom.home.programs.waybar;
    swaylockcfg = config.custom.home.programs.swaylock;
    xscreensavercfg = config.custom.home.programs.xscreensaver;
    scripts = (import ./scripts) pkgs lib clib config;
    geolocation = ageOrDefault config "geolocation" "0.00:0.00";
  in mkMerge [(opt {
    shortcuts = import ./shortcuts pkgs lib config;
  })
  {
    custom.home.opts = {
      sessions = [ sway ];
      aliases = {
        sway = mkIf (config.custom.common.opts.hardware.gpu.vendor == enums.gpu-vendors.nvidia) "${sway}/bin/sway --unsupported-gpu";
        screens = "${sway}/bin/swaymsg -t get_outputs | ${jq}/bin/jq -r '.[] | .name + \"\\t\" + .make + \" \" + .model + \" \" + .serial'";
      };
    };

    home.packages = mkMerge [
      [
        (let
          wallpaperDir = config.custom.home.opts.wallpaper.dir;
          forEachScreen = render: pipe config.custom.home.opts.screens [
            attrsToList
            (map render)
            concatLines
          ];
        in writeShellScriptBin "wallpaper" ''
          set_default () {
            ${coreutils}/bin/ln -sf default "${wallpaperDir}/lockscreen"
            ${forEachScreen (screen: ''
              ${coreutils}/bin/ln -sf default "${wallpaperDir}/${screen.name}"
            '')}
          }

          set_wallpaper () {
            outname="$1"
            filename="$(${coreutils}/bin/realpath -s --relative-to="${wallpaperDir}" "$2")"
            ${coreutils}/bin/ln -sf "$filename" "${wallpaperDir}/$outname"
          }

          set_from_dir () {
            dirname="$(${coreutils}/bin/realpath -s "$1")"
            for filename in "$dirname/"*; do
              outname="$(${coreutils}/bin/basename "$filename")"
              set_wallpaper "$outname" "$filename"
            done
          }

          reload_wallpapers () {
            ${sway}/bin/swaymsg 'output "*" bg "${wallpaperDir}/default" fill #000000'
            ${forEachScreen (screen: ''
              ${if screen.value.noserial then ''
                ${sway}/bin/swaymsg 'output "${screen.name} Unknown" bg "${wallpaperDir}/${screen.name}" fill #000000'
              '' else ""}
              ${sway}/bin/swaymsg 'output "${screen.name}" bg "${wallpaperDir}/${screen.name}" fill #000000'
            '')}
          }

          if [[ $# == 1 ]]; then
            filename="$1"
            if [[ -d $filename ]]; then
              set_default
              set_from_dir "$filename"
            elif [[ -f $filename ]]; then
              set_default
              outname="default"
              set_wallpaper "$outname" "$filename"
            else
              echo "invalid file"
              exit 1
            fi
            reload_wallpapers
          elif [[ $# == 2 ]]; then
            outname="$1"
            filename="$2"
            set_wallpaper "$outname" "$filename"
            reload_wallpapers
          else
            echo "Usage: wallpaper [link] file"
            exit 1
          fi
        '')
      ]
      (mkIf (cfg.brightnessDevice != null) [
        brightnessctl
      ])
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

    xdg.configFile."gammastep/hooks/log-period.sh".source = mkIf cfg.blueLightFilter (writeShellScript "gammastep-log-period-hook" ''
      case $1 in
        period-changed)
          exec echo $3 > ${config.custom.home.behavior.tmpfiles."gammastep-period-output".path}
      esac
    '');

    wayland.systemd.target = "sway-session.target";

    wayland.windowManager.sway = {
      enable = true;
      package = sway;

      systemd.xdgAutostart = true;
      xwayland = true;
      config = rec {
        modifier = "Mod4";
        terminal = "${kitty}/bin/kitty";
        menu = "${scripts.menu} -d | xargs ${sway}/bin/swaymsg exec --";
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
          screen-def = screen.value.sway // {
            bg = "\"${config.custom.home.opts.wallpaper.dir}/${screen.name}\" fill #000000";
          };
        in {
          # don't mkIf this one! some options don't work otherwise!
          "${screen.name}" = screen-def;
          "${screen.name} Unknown" = mkIf screen.value.noserial screen-def;
        })) {
          "*" = {
            bg = "\"${config.custom.home.opts.wallpaper.dir}/default\" fill #000000";
          };
        } (attrsToList config.custom.home.opts.screens);

        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
          alt = "Mod1";
          shortcuts-launcher = import ./shortcuts/launcher.nix pkgs lib config scripts.menu;
          lock = "${swaylock}/bin/swaylock";
          ss = "${xscreensaver}/bin/xscreensaver-command -activate";
          ss-lock = "exec ${writeShellScript "screensaver-lock" ''
            ${ss}
            ${xscreensaver}/bin/xscreensaver-command -watch | while read line; do
              [[ "$line" == "UNBLANK"* ]] && ${procps}/bin/pkill -P $$ xscr
            done
            ${lock}
          ''}";
          qs-ipc = "${quickshell}/bin/qs ipc -i $(${quickshell}/bin/qs list --all --json | ${jq}/bin/jq -r '.[].id') call main";
        in lib.mkOptionDefault { # append to default behavior

          # Media keys: Audio
          "XF86AudioRaiseVolume" = if waybarcfg.enable then "exec ${scripts.volume} up" else "exec ${qs-ipc} volume up";
          "XF86AudioLowerVolume" = if waybarcfg.enable then "exec ${scripts.volume} down" else "exec ${qs-ipc} volume down";
          "XF86AudioMute" = "exec ${scripts.volume} mute";
          "XF86AudioMicMute" = "exec ${scripts.volume} micmute";

          # Media keys: Display
          "XF86MonBrightnessUp" = mkIf (cfg.brightnessDevice != null) "exec ${scripts.brightness} up";
          "XF86MonBrightnessDown" = mkIf (cfg.brightnessDevice != null) "exec ${scripts.brightness} down";
          "XF86Display" = mkIf cfg.blueLightFilter "exec pkill -USR1 gammastep";
          "XF86Favorites" = mkIf swaylockcfg.enable "exec ${swaylock}/bin/swaylock & systemctl suspend";
          "${modifier}+Shift+delete" = mkIfElse swaylockcfg.enable (
            mkIfElse xscreensavercfg.enable "exec ${ss-lock}" "exec ${lock}"
          ) (
            mkIf xscreensavercfg.enable "exec ${ss}"
          );
          "${modifier}+${alt}+Shift+delete" = mkIf (swaylockcfg.enable && xscreensavercfg.enable) "exec ${lock}";

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

          "${modifier}+${alt}+d" = "sticky toggle";

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
        bars = mkIfElse waybarcfg.enable [{
          "command" = "${waybar}/bin/waybar";
        }] (mkForce []);
        colors = rec {
          background = colorschemecfg.wm.background;
          focused = {
            inherit background;
            border = colorschemecfg.wm.foreground-normal;
            childBorder = colorschemecfg.wm.foreground-normal;
            indicator = colorschemecfg.wm.foreground-normal;
            text = colorschemecfg.wm.text;
          };
          unfocused = {
            inherit background;
            border = colorschemecfg.wm.foreground-dim;
            childBorder = colorschemecfg.wm.foreground-dim;
            indicator = colorschemecfg.wm.foreground-dim;
            text = colorschemecfg.wm.text;
          };
          urgent = {
            inherit background;
            border = colorschemecfg.wm.foreground-alert;
            childBorder = colorschemecfg.wm.foreground-alert;
            indicator = colorschemecfg.wm.foreground-alert;
            text = colorschemecfg.wm.text;
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
          #   command = "pkill xss-lock; ${xss-lock}/bin/xss-lock --ignore-sleep ${swaylock}/bin/swaylock --ring-color=\"#000044\"";
          #   always = true;
          # }
          {
            command = "pkill dunst; ${dunst}/bin/dunst";
            always = true;
          }
          (mkIf cfg.blueLightFilter {
            command = "pkill -9 gammastep; ${gammastep}/bin/gammastep -l $(cat ${geolocation}) -t 6500:${toString cfg.blueLightStrength}";
            always = true;
          })
        ];
      };
      extraConfig = ''
        titlebar_padding 4 1
        font pango:monospace 7.68

        bindgesture swipe:4:left workspace prev_on_output
        bindgesture swipe:4:right workspace next_on_output
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
  }]);
}
