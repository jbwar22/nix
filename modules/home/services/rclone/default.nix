{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "rclone";
    logDir = mkOption {
      description = "directory to write log files";
      type = with types; nullOr str;
      default = null;
    };
    combinedPackage = mkOption {
      type = with types; nullOr package;
      default = null;
    };
    configs = mkOfSubmoduleOption "configs for services" types.attrsOf {
      oncalendar = mkOption {
        description = "set oncalendar for systemd timer, and create systemd service";
        type = with types; nullOr str;
        default = null;
      };
      rcloneargs = mkNullOrStrOption "args for rclone script";
      rcloneconf = mkNullOrStrOption "str path to rclone config file";
      inCombined = mkDisableOption "in rclone-all script";
    };
  };

  config = mkIf cfg.enable (let
    configs = filterAttrs (name: c: let 
      valid = c.rcloneargs != null && c.rcloneconf != null;
    in warnIfNot valid "missing agenix files for rclone def ${name}" valid) cfg.configs;
    packaged = mapAttrs (name: c: {
      inherit (c) oncalendar inCombined;
      package = let
        ifLog = t: if cfg.logDir != null then t else "";
        logfile = ifLog "${cfg.logDir}/rclone-${name}.log";
        logarg = ifLog  "--log-file ${logfile}";
        wipelog = ifLog "echo > ${logfile}";
        logtime = ifLog ''
          ${pkgs.coreutils}/bin/date >> ${logfile}
          echo >> ${logfile}
        '';
      in pkgs.writeShellScriptBin "rclone-${name}" ''
        echo executing rclone
        ${wipelog}
        ${logtime}
        ${pkgs.findutils}/bin/xargs ${pkgs.rclone}/bin/rclone --config=${c.rcloneconf} ${logarg} < ${c.rcloneargs}
        ${logtime}
        echo rclone completed
      '';
    }) configs;
    service-packages = filterAttrs (_name: c: c.oncalendar != null) packaged;
    has-any-services = (attrNames service-packages) != [];
    combined-packages = filterAttrs (_name: c: c.inCombined) packaged;
  in mkMerge [
    {
      systemd.user.enable = mkIf has-any-services (mkDefault true);

      systemd.user.services = mapAttrs' (name: c: {
        name = "rclone-${name}";
        value = {
          Unit.Description = "service for rclone config: ${name}";
          Service = {
            ExecStart = c.package;
          };
        };
      }) service-packages;

      systemd.user.timers = mapAttrs' (name: c: {
        name = "rclone-${name}";
        value = {
          Install.WantedBy = [ "timers.target" ];
          Timer.OnCalendar = c.oncalendar;
          Unit.Description = "timer for rclone config: ${name}";
        };
      }) service-packages;

      home.packages = mkMerge [
        (mapAttrsToList (_name: c: c.package) packaged)
      ];
    }
    (let
      combined-packages-list = mapAttrsToList (_name: c: c.package) combined-packages;
      has-combined-package = combined-packages-list != [];
    in opt {
      combinedPackage = mkIf has-combined-package (let
        signal-file = "/tmp/rclone-all-status";
        signal = index: total: ''
          echo ${toString index}/${toString total} > ${signal-file}
          ${pkgs.procps}/bin/pkill -RTMIN+6 waybar
        '';
        lines = pipe combined-packages-list [
          enumerate
          (map (p: ''
            ${signal p.index count}
            ${getExe p.value}
          ''))
          (concatStringsSep "\n")
        ];
        count = length combined-packages-list; 
      in pkgs.writeShellScriptBin "rclone-all" ''
        ${lines}
        ${signal count count}
        ${pkgs.coreutils}/bin/sleep 2
        rm ${signal-file}
        ${pkgs.procps}/bin/pkill -RTMIN+6 waybar
      '');
    })
  ]);
}
