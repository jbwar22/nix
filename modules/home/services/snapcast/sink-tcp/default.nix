{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "sink-tcp";
  };

  config = mkIf cfg.enable {
    systemd.user.enable = mkDefault true;
    systemd.user.services.snapcast-local-tcp-sink = {
      Unit = {
        Description = "tcp sink for local snapcast snapserver";
        Requires = [ "pipewire.service" ];
        After = "pipewire.target";
      };
      Service = {
        ExecStart = pkgs.writeShellScript "snapcast-local-fifo-sink" ''
          ${pkgs.pulseaudio}/bin/pactl unload-module \
            $(${pkgs.pulseaudio}/bin/pactl list | \
              ${pkgs.gnugrep}/bin/grep -B 2 "sink_name=Snapcast(local,tcp)" | \
              ${pkgs.coreutils}/bin/head -1 | \
              ${pkgs.coreutils}/bin/cut -c 9-) || true
          ${pkgs.coreutils}/bin/sleep 1
          ${pkgs.pulseaudio}/bin/pactl load-module module-pipe-sink \
            sink_name="Snapcast(local,tcp)" \
            file=/run/snapserver/snapfifo \
            format=s16le \
            rate=48000
        '';
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
