{ config, lib, pkgs, ... }:

with lib; with ns config ./.; let
  colorscheme = config.custom.home.opts.colorscheme;
in {
  options = opt {
    enable = mkEnableOption "waybar";
    memoryWidth = mkOption {
      type = with types; int;
      default = 8;
      description = "width of memory status";
    };
  };

  config = lib.mkIf cfg.enable (let

    clonck = pkgs.callPackage ../../../../packages/clonck.nix {};

    progress = import ./progress-bars.nix;

    battery = conf: {
      interval = 10;
      states = {
        critical = 15;
      };
      tooltip = false;
      format-time = " {H}h{M}m";
      format = "B[<span font-size=\"${conf.status-font-size}\">{icon}</span>]";
      format-alt = "B[{capacity:>2}%{time}]";
      format-critical = "B[<span font-size=\"${conf.status-font-size}\">{icon}</span>]";
      format-critical-alt = "B[{capacity:>2}%{time}]";
      format-alt-critical = "B[{capacity:>2}%{time}]";
      format-icons = progress.horizontal.step4x8;
    };

    bar-batteries = conf: foldl' (accum: x:
      accum // {
        "battery#${toLower x.name}" = (battery conf) // {
          bat = x.name;
          full-at = x.value.max;
        };
      }) {} (attrsToList config.custom.common.opts.hardware.batteries);

    bar-base = conf: rec {
      layer = "top";
      position = "top";
      height = 20;
      spacing = 0;
      modules-left = [
        "sway/workspaces"
        "sway/mode"
        "sway/scratchpad"
        "custom/clockdate"
      ];
      modules-center = [
        "sway/window"
      ];
      modules-right = [
        "custom/extras"
        "custom/lang"
        "network"
        "pulseaudio"
        "custom/dunst"
        "cpu"
        "memory"
        "battery#bat0"
        "battery#bat1"
      ];
      
      # Modules configuration
      "sway/workspaces" = {
        disable-scroll = true;
        format = "{icon}";
        format-icons = {
          "1" = "一";
          "2" = "二";
          "3" = "三";
          "4" = "四";
          "5" = "五";
          "6" = "六";
          "7" = "七";
          "8" = "八";
          "9" = "九";
          "10" = "十";
        };
      };

      "sway/mode" = {
        format = "{}";
      };

      "sway/scratchpad" = {
        format = "{count}{icon}";
        show-empty = false;
        format-icons = ["" "他"];
        tooltip = true;
        tooltip-format = "{app}: {title}";
      };

      "cpu" = let
        icons = concatStrings (map (x:
          "{icon${toString x}}"
        ) (range 0 (config.custom.common.opts.hardware.cpu.threads - 1)));
        test-str = if hasAttr "test-str" conf then conf.test-str else "";
      in {
        interval = 1;
        format = "${test-str}C<span>[<span font-size=\"${conf.status-font-size}\">${icons}</span>]</span>";
        format-alt = "C[{usage:>2}]";
        tooltip = false;
        format-icons = progress.vertical.step1x8;
      };

      "memory" = {
        interval = 1;
        format = "M<span>[<span font-size=\"${conf.status-font-size}\">{icon}</span>]</span>";
        format-alt = "M[{percentage:>2}]";
        tooltip = false;
        format-icons = progress.horizontal."step${toString cfg.memoryWidth}x4";
      };

      "network" = {
        format-wifi = "W";
        format-ethernet = "E";
        format-linked = "C";
        format-disconnected = "D";
        format-alt = "{essid} {ifname}:{ipaddr}";
        tooltip = false;
      };

      "pulseaudio" = {
        format = "V{volume} {format_source}";
        format-muted = "VM {format_source}";
        format-bluetooth = "V{volume}B {format_source}";
        format-bluetooth-muted = "VMB {format_source}";
        format-source = "MU";
        format-source-muted = "MM";
        format-alt = "{desc}";
        tooltip = false;
      };

      # Custom modules configuration
      "custom/clockdate" = {
        format = "{}";
        escape = true;
        tooltip = false;
        # TODO nixify
        exec = "${clonck}/bin/clonck";
      };
      "custom/lang" = {
        format = "{}";
        escape = true;
        tooltip = false;
        exec = pkgs.writeShellScript "waybar-fcitx5" ''
          set -euo pipefail
          while true; do
            engine=$(fcitx5-remote -n)
            # engine="keyboard-us"
            if [[ $? == "1" ]] || [[ $engine == "keyboard-us" ]]; then
              echo EN
            else
              echo JP
            fi
            sleep 1
          done
        '';
      };

      "custom/extras" = {
        format = "{}";
        escape = true;
        tooltip = false;
        interval = 1;
        exec = pkgs.writeShellScript "waybar-extras" ''
          extras="["
          
          if hciconfig | head -3 | tail -1 | grep UP > /dev/null; then
            extras="''${extras}B"
          fi

          if [ -d /sys/class/net/wg ]; then
            extras="''${extras}V"
          fi

          if nmcli con show --active | awk '{print $3}' | grep vpn > /dev/null || nmcli con show --active | awk '{print $3}' | grep wireguard > /dev/null; then
            extras="''${extras}V"
          fi

          # TODO conditional
          if [[ "$(cat ${config.custom.home.behavior.tmpfiles."gammastep-period-output".path})" == "night" ]] || \
             [[ "$(cat ${config.custom.home.behavior.tmpfiles."gammastep-period-output".path})" == "transition" ]]; then
            extras="''${extras}G"
          fi

          if [ "$extras" != "[" ]; then
            echo "''${extras}]"
          else
            echo
          fi
        '';
      };

      "custom/dunst" = {
        format = "{}";
        tooltip = false;
        signal = 5; # instant update on click, also triggered by dunst
        on-click = pkgs.writeShellScript "waybar-dunst-pause" ''
          if ${pkgs.dunst}/bin/dunstctl is-paused | grep true > /dev/null; then
            ${pkgs.dunst}/bin/dunstctl set-pause-level 0
            pkill -RTMIN+5 waybar
          else
            ${pkgs.dunst}/bin/dunstctl set-pause-level 50
            pkill -RTMIN+5 waybar
          fi
        '';
        exec = pkgs.writeShellScript "waybar-dunst" ''
          if ${pkgs.dunst}/bin/dunstctl is-paused | grep true > /dev/null; then
            echo -n N
            ${pkgs.dunst}/bin/dunstctl count waiting
          else
            echo N~
          fi
        '';
      };
    } // (bar-batteries conf);

    bar-defs = {
      "bar768" = let
        conf.status-font-size = "76%";
      in (bar-base conf) // {
        height = 20;
      };

      "bar1440" = let
        conf.status-font-size = "68%";
      in (bar-base conf) // {
        height = 29;
      };

      "bar1080" = let
        conf.status-font-size = "70%";
      in (bar-base conf) // {
        height = 26;
      };
    };

    screens = config.custom.home.opts.screens.config;
    screen-id = screen-name: replaceStrings [" "] ["-"] screen-name;

    bar-names-by-id = foldl' (accum: screen: accum // {
      "${(screen-id screen.name)}" = screen.bar;
    }) {} screens;

    bars = map (screen: bar-defs.${screen.bar} // rec {
      id = screen-id screen.name;
      name = id;
      output = [ screen.name ];
    }) screens;

    # helper for css: select by bar, then additional selection
    mkselect = bar-name: select: 
      let
        selectors = map (bar-def: "#waybar.${bar-def.name} ${select}") (filter (bar: (bar-names-by-id."${bar.id}") == bar-name) bars);
      in
        if (selectors == []) then
          "#UNUSED"
        else
          (concatStringsSep ", " selectors);

    style = import ./style.nix mkselect colorscheme;

  in {

    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      
      settings = bars;

      inherit style;
      
    };

  });
}
