{ ns, config, ... }:

ns.enable {
  custom.home = {
    programs.bash.sourcedFiles = [ "~/work/scripts/workrc" ];
    behavior.impermanence.paths = [
      "work"
      ".aws"
    ];
  };

  systemd.user = {
    services.work-hourly = {
      Unit.Description = "hourly work script";
      Service = {
        ExecStart = "/home/${config.home.username}/work/scripts/hourly";
      };
    };
    timers.work-hourly = {
      Unit.Description = "timer for hourly work script";
      Install.WantedBy = [ "timers.target" ];
      Timer = {
        OnActiveSec = "1h";
        OnUnitActiveSec = "1h";
      };
    };
  };
}
