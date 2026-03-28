ipkgs: inputs:

inputs.wrappers.lib.wrapPackage ({ config, wlib, lib, pkgs, ... }: {
  options = with lib; {
    # cursorTheme = true;
    # screens = true;
    # bar = true;
    # blueLightStrength = true;
    colorscheme = mkOption {

    };
    terminal = mkOption {
      type = types.str;
      default = "${pkgs.kitty}/bin/kitty";
    };
  };

  config = {
    pkgs = ipkgs;

    package = (pkgs.sway.override {
      sway-unwrapped = pkgs.sway-unwrapped.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [
          ./sway-hidecursor.patch
        ];
      });
    });
    env = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "sway";
      NIXOS_OZONE_WL = "1";
    };
    flags = {
      "--unsupported-gpu" = true;
      "--config" = pkgs.writeTextFile {
        name = "sway.conf";
        text = let
          c = config.colorscheme.wm;
        in ''
          # top level settings

          font pango:monospace 7.68
          floating_modifier Mod4
          default_border pixel 2
          default_floating_border normal 2
          hide_edge_borders smart
          focus_wrapping no
          focus_follows_mouse yes
          focus_on_window_activation smart
          mouse_warping output
          workspace_layout default
          workspace_auto_back_and_forth no
          titlebar_padding 4 1


          # colors

          # border background text indicator child_border
          client.focused ${c.foreground-normal} ${c.background} ${c.text} ${c.foreground-normal} ${c.foreground-normal}
          client.focused_inactive ${c.foreground-dim} ${c.background} ${c.text} ${c.foreground-dim} ${c.foreground-dim}
          client.unfocused ${c.foreground-dim} ${c.background} ${c.text} ${c.foreground-dim} ${c.foreground-dim}
          client.urgent ${c.foreground-alert} ${c.background} ${c.text} ${c.foreground-alert} ${c.foreground-alert}
          client.placeholder ${c.foreground-dim} ${c.background} ${c.text} ${c.foreground-dim} ${c.foreground-dim}
          client.background ${c.background}


          # keybinds

          bindsym Mod4+1 workspace number 1
          bindsym Mod4+2 workspace number 2
          bindsym Mod4+3 workspace number 3
          bindsym Mod4+4 workspace number 4
          bindsym Mod4+5 workspace number 5
          bindsym Mod4+6 workspace number 6
          bindsym Mod4+7 workspace number 7
          bindsym Mod4+8 workspace number 8
          bindsym Mod4+9 workspace number 9
          bindsym Mod4+0 workspace number 10
          bindsym Mod4+Shift+1 move container to workspace number 1
          bindsym Mod4+Shift+2 move container to workspace number 2
          bindsym Mod4+Shift+3 move container to workspace number 3
          bindsym Mod4+Shift+4 move container to workspace number 4
          bindsym Mod4+Shift+5 move container to workspace number 5
          bindsym Mod4+Shift+6 move container to workspace number 6
          bindsym Mod4+Shift+7 move container to workspace number 7
          bindsym Mod4+Shift+8 move container to workspace number 8
          bindsym Mod4+Shift+9 move container to workspace number 9
          bindsym Mod4+Shift+0 move container to workspace number 10

          bindsym Mod4+Mod1+greater move workspace to output up
          bindsym Mod4+Mod1+less move workspace to output down
          bindsym Mod4+Mod1+s layout stacking
          bindsym Mod4+Mod1+space focus mode_toggle

          bindsym Mod4+Return exec ${config.terminal}
          bindsym Mod4+Mod1+Shift+s exec ${screenshot} -f
          bindsym Mod4+Mod1+Shift+t exec ${screenshot} -cf

          bindsym Mod4+Shift+a focus child
          bindsym Mod4+Shift+c reload
          bindsym Mod4+Shift+delete exec /nix/store/ns719zszlzs7yvjhgzjmip5mb2r8g6h4-swaylock-1.8.4/bin/swaylock
          bindsym Mod4+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'
          bindsym Mod4+Shift+h move left
          bindsym Mod4+Shift+j move down
          bindsym Mod4+Shift+k move up
          bindsym Mod4+Shift+l move right
          bindsym Mod4+Shift+minus move scratchpad
          bindsym Mod4+Shift+q kill
          bindsym Mod4+Shift+s exec /nix/store/ffjjvphh29jk93w22s1wn15lrnna8ks1-sway-screenshot
          bindsym Mod4+Shift+space floating toggle
          bindsym Mod4+Shift+t exec /nix/store/ffjjvphh29jk93w22s1wn15lrnna8ks1-sway-screenshot -c

          bindsym Mod4+a focus parent
          bindsym Mod4+b splith
          bindsym Mod4+d exec /nix/store/1wxvl2c7z250wafj8xpvi6vrdx0qlnwq-sway-menu -d | xargs /nix/store/aqn5lwpa00n3ibh9gffvwkk6sxhdm9f5-sway-1.11/bin/swaymsg exec --
          bindsym Mod4+e layout toggle split
          bindsym Mod4+f fullscreen toggle
          bindsym Mod4+greater move workspace to output right
          bindsym Mod4+h focus left
          bindsym Mod4+j focus down
          bindsym Mod4+k focus up
          bindsym Mod4+l focus right
          bindsym Mod4+less move workspace to output left
          bindsym Mod4+minus scratchpad show
          bindsym Mod4+r mode resize
          bindsym Mod4+s exec /nix/store/g2gackpp3xjcsrg9ryhbjk8sd05pylvm-shortcuts-launcher

          bindsym Mod4+v splitv
          bindsym Mod4+w layout tabbed
          bindsym Mod4+x exec /nix/store/i4hhra9pn3qvxk0b9j3mxpxbgkwzl3pz-shortcuts-runner
          bindsym XF86AudioLowerVolume exec /nix/store/3h4z1zy8mzy26ki6v1bslni9ak4m6ar0-sway-volume down
          bindsym XF86AudioMicMute exec /nix/store/3h4z1zy8mzy26ki6v1bslni9ak4m6ar0-sway-volume micmute
          bindsym XF86AudioMute exec /nix/store/3h4z1zy8mzy26ki6v1bslni9ak4m6ar0-sway-volume mute
          bindsym XF86AudioRaiseVolume exec /nix/store/3h4z1zy8mzy26ki6v1bslni9ak4m6ar0-sway-volume up
          bindsym XF86Display exec pkill -USR1 gammastep
          bindsym XF86Favorites exec /nix/store/ns719zszlzs7yvjhgzjmip5mb2r8g6h4-swaylock-1.8.4/bin/swaylock & systemctl suspend

          input "type:keyboard" {
            dwt disabled
            repeat_delay 350
            repeat_rate 40
          }

          input "type:pointer" {
            accel_profile flat
            dwt disabled
          }

          input "type:touchpad" {
            accel_profile adaptive
            click_method clickfinger
            dwt disabled
            natural_scroll enabled
            tap enabled
          }

          input "1133:49291:Logitech_G502_HERO_Gaming_Mouse" {
            pointer_accel -0.5
            scroll_factor 0.5
          }

          input "12375:2:PIXART_VAXEE_Mouse" {
            pointer_accel 0
            scroll_factor 0.7
          }

          input "12375:3:PIXART_VAXEE_Wireless_Mouse" {
            pointer_accel 0
            scroll_factor 0.7
          }

          input "1739:0:Synaptics_TM3276-022" {
            scroll_factor 0.5
          }

          input "1:1:AT_Translated_Set_2_keyboard" {

          }

          input "2362:628:PIXA3854:00_093A:0274_Touchpad" {
            scroll_factor 0.5
          }

          input "4809:4809:HID_12c9:1002_Mouse" {

          }

          input "9610:39:SINOWEALTH_Wired_Gaming_Mouse" {

          }

          output "*" {
            bg /nix/store/kmrwl0m4ndr22y1wd4hmy2n5dfvqq4cx-iyxxfe0y.png fill
          }

          output "ASUSTek COMPUTER INC VG278 J8LMQS104073" {
            adaptive_sync off
            bg /nix/store/kmrwl0m4ndr22y1wd4hmy2n5dfvqq4cx-iyxxfe0y.png fill
            position 0 0
            resolution 1920x1080@144.001Hz
          }

          output "ASUSTek COMPUTER INC VG27AQL1A S1LMQS102258" {
            adaptive_sync off
            bg /nix/store/kmrwl0m4ndr22y1wd4hmy2n5dfvqq4cx-iyxxfe0y.png fill
            position 1920 0
            resolution 2560x1440@170.004Hz
            transform 0
          }

          output "Acer Technologies XV271U M3 140400E433LIJ" {
            resolution 2560x1440@143.999Hz
          }

          output "BNQ BenQ GW2780 V1J07047SL0" {
            bg /nix/store/kmrwl0m4ndr22y1wd4hmy2n5dfvqq4cx-iyxxfe0y.png fill
            position 4480 0
            resolution 1920x1080@60.000Hz
          }

          output "BOE 0x06B3" {
            resolution 1366x768@60.058Hz
          }

          output "BOE 0x06B3 Unknown" {
            resolution 1366x768@60.058Hz
          }

          output "BOE NE135A1M-NY1" {
            resolution 2880x1920@120.000Hz
          }

          output "BOE NE135A1M-NY1 Unknown" {
            resolution 2880x1920@120.000Hz
          }

          output "Hewlett Packard HP 22cwa 6CM6120J0Z" {
            resolution 1920x1080@60.000hz
          }

          output "LG Electronics LG TV 0x01010101" {
            resolution 1920x1080@60.000hz
          }

          output "XXX Beyond TV 0x00010000" {
            resolution 4096x2160@60.000Hz
            scale 2
          }

          seat "*" {
            hide_cursor 500
            xcursor_theme macOS 24
          }

          mode "resize" {
            bindsym Down resize grow height 10 px
            bindsym Escape mode default
            bindsym Left resize shrink width 10 px
            bindsym Return mode default
            bindsym Right resize grow width 10 px
            bindsym Up resize shrink height 10 px
            bindsym h resize shrink width 10 px
            bindsym j resize grow height 10 px
            bindsym k resize shrink height 10 px
            bindsym l resize grow width 10 px
          }

          bar {
            font pango:monospace 8.000000
            swaybar_command /nix/store/ch7wfi3wy6np8dfgfv6rrvkx185bp27k-waybar-0.15.0/bin/waybar
          }

          gaps inner 4
          gaps outer -4
          for_window [window_role="pop-up"] floating enable
          for_window [window_role="task_dialog"] floating enable
          for_window [app_id="firefox" title="Firefox - Choose User Profile"] floating enable
          for_window [app_id="librewolf" title="LibreWolf - Choose User Profile"] floating enable
          for_window [app_id="librewolf" title="Save As"] resize set height 600
          for_window [app_id="librewolf" title="Save As"] resize set width 1200
          for_window [title="Extension: (Bitwarden Password Manager) - Bitwarden — LibreWolf"] floating enable
          exec_always pkill dunst; /nix/store/sgh4z346d28bks48d153q6byhswr7sj9-dunst-1.13.1/bin/dunst

          exec_always pkill -9 gammastep; /nix/store/38rgln3gzbb4imf77b4vmhisq3gnpq1j-gammastep-2.0.11/bin/gammastep -l $(cat /run/user/1000/agenix/geolocation) -t 6500:5000

          exec "/nix/store/rqvknlking3j6bwi2v0da9m8bza8wlyd-dbus-1.14.10/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIXOS_OZONE_WL XCURSOR_THEME XCURSOR_SIZE; systemctl --user reset-failed && systemctl --user start sway-session.target && swaymsg -mt subscribe '[]' || true && systemctl --user stop sway-session.target"
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










          # launch window floating support

          set $PROP none
          for_window [shell="."] mark --add "prop:$$PROP:"
          for_window [con_mark=^prop.*:floating:] floating enable
          for_window [con_mark=^prop.*:fullscreen:] fullscreen enable
          for_window [con_mark=^prop.*:shellpopup:] floating enable ; resize set width 1000 ; resize set height 55
          for_window [con_mark=^prop:] mark --toggle "prop:$$PROP:" ; set $$PROP none
        '';
      };
    };
  };
})
