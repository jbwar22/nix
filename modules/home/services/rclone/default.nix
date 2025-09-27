{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "rclone";
    _combined = mkOption {
      type = with types; listOf package;
      default = [];
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
      package = pkgs.writeShellScriptBin "rclone-${name}" ''
        echo executing rclone
        ${pkgs.findutils}/bin/xargs ${pkgs.rclone}/bin/rclone --config=${c.rcloneconf} < ${c.rcloneargs}
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
    (opt {
      _combined = (mapAttrsToList (_name: c: c.package) combined-packages);
    })
  ]);
}
