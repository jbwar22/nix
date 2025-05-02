{ config, lib, pkgs, inputs, ... }:

with lib; with ns config ./.; let
  colorscheme = config.custom.home.opts.colorscheme;
in {
  options = opt {
    enable = mkEnableOption "waybar";
    memoryWidth = mkOption {
      type = with types; int;
      default = 12;
      description = "width of memory status";
    };
  };

  config = lib.mkIf cfg.enable (let

    clonck = inputs.clonck.packages.${pkgs.system}.clonck;

    progress = import ./progress-bars.nix lib;

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
      format-icons = progress.getHorizontal 4 8;
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
      ] ++ (pipe config.custom.common.opts.hardware.batteries [
        attrsToList
        (map (x: "battery#${toLower x.name}"))
      ]);
      
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
        format-icons = progress.getHorizontal cfg.memoryWidth 8;
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
        exec = pkgs.writeShellScript "waybar-extras" ''
          bluetooth=""
          vpn=""
          gammastep=""
          {(
            while true
            do
              echo bluetooth
              sleep 5
            done
          ) & (
            echo vpn
            ${pkgs.networkmanager}/bin/nmcli monitor \
            | ${pkgs.coreutils}/bin/stdbuf -oL \
              ${pkgs.gnugrep}/bin/grep -E '.*: connected|.*: disconnected' \
            | while read line
            do
              echo vpn
            done
          ) & (
            echo gammastep
            ${pkgs.inotify-tools}/bin/inotifywait -m -e close_write \
            ${config.custom.home.behavior.tmpfiles."gammastep-period-output".path} \
            2>/dev/null \
            | while read line
            do
              echo gammastep
            done
          )} | while read line
          do
            case $line in
              bluetooth)
                if ${pkgs.bluez}/bin/hciconfig \
                   | ${pkgs.coreutils}/bin/head -3 \
                   | ${pkgs.coreutils}/bin/tail -1 \
                   | ${pkgs.gnugrep}/bin/grep UP > /dev/null
                then
                  bluetooth="B"
                else
                  bluetooth=""
                fi
                ;;
              vpn)
                if ${pkgs.networkmanager}/bin/nmcli con show --active \
                   | ${pkgs.gawk}/bin/awk '{print $3}' \
                   | ${pkgs.gnugrep}/bin/grep vpn > /dev/null \
                || ${pkgs.networkmanager}/bin/nmcli con show --active \
                   | ${pkgs.gawk}/bin/awk '{print $3}' \
                   | ${pkgs.gnugrep}/bin/grep wireguard > /dev/null \
                || [ -d /sys/class/net/wg ]
                then
                  vpn="V"
                else
                  vpn=""
                fi
                ;;
              gammastep)
                if [[ "$(${pkgs.coreutils}/bin/cat ${config.custom.home.behavior.tmpfiles."gammastep-period-output".path})" == "night" ]] || \
                   [[ "$(${pkgs.coreutils}/bin/cat ${config.custom.home.behavior.tmpfiles."gammastep-period-output".path})" == "transition" ]]
                then
                  gammastep="G"
                else
                  gammastep=""
                fi
                ;;
              *)
                exit 1
                ;;
            esac
            extras="[''${bluetooth}''${vpn}''${gammastep}]"
            if [ "$extras" != "[]" ]
            then
              echo $extras
            else
              echo
            fi
          done
        '';
      };

      "custom/dunst" = {
        format = "{}";
        tooltip = false;
        signal = 5; # instant update on click, also triggered by dunst
        on-click = pkgs.writeShellScript "waybar-dunst-pause" ''
          # reference pause levls in dunst module
          if [ "$(${pkgs.dunst}/bin/dunstctl get-pause-level)" == 0 ]; then
            ${pkgs.dunst}/bin/dunstctl set-pause-level 50
          elif [ "$(${pkgs.dunst}/bin/dunstctl get-pause-level)" == 50 ]; then
            ${pkgs.dunst}/bin/dunstctl set-pause-level 70
          elif [ "$(${pkgs.dunst}/bin/dunstctl get-pause-level)" == 70 ]; then
            ${pkgs.dunst}/bin/dunstctl set-pause-level 0
          fi
          ${pkgs.procps}/bin/pkill -RTMIN+5 waybar
        '';
        exec = pkgs.writeShellScript "waybar-dunst" ''
          if [ "$(${pkgs.dunst}/bin/dunstctl get-pause-level)" == 0 ]; then
            echo ND~
          elif [ "$(${pkgs.dunst}/bin/dunstctl get-pause-level)" == 50 ]; then
            echo -n NW
            ${pkgs.dunst}/bin/dunstctl count waiting
          elif [ "$(${pkgs.dunst}/bin/dunstctl get-pause-level)" == 70 ]; then
            echo -n NF
            ${pkgs.dunst}/bin/dunstctl count waiting
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

      "bar1920_2x" = let
        conf.status-font-size = "72%";
      in (bar-base conf) // {
        height = 22;
      };
    };

    screensList = attrsToList config.custom.home.opts.screens;
    screen-id = screen-name: replaceStrings [" "] ["-"] screen-name;

    bar-names-by-id = pipe screensList [
      (map (screen: {
        name = screen-id screen.name;
        value = screen.value.bar;
      }))
      listToAttrs
    ];

    bars = map (screen: bar-defs.${screen.value.bar} // rec {
      id = screen-id screen.name;
      name = id;
      output = [ screen.name ];
    }) screensList;

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
