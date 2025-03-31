{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "rclone";
    configs = mkOfSubmoduleOption "configs for services" types.attrsOf {
      oncalendar = mkStrOption "systemd timer oncalendar";
      rcloneargs = mkNullOrStrOption "args for rclone script";
      rcloneconf = mkNullOrStrOption "str path to rclone config file";
    };
  };

  config = mkIf cfg.enable (let
    checkc = c: c.rcloneargs != null && c.rcloneconf != null;
  in {
    systemd.user.enable = mkDefault true;

    systemd.user.services = mapAttrs' (name: c: {
      name = "rclone-${name}";
      value = if checkc c then {
        Unit = {
          Description = "service for rclone config: ${name}";
          Requires = [ "default.target" "agenix.service" ];
        };
        Service = {
          ExecStart = pkgs.writeShellScript "rclone: ${name}" ''
            echo executing rclone
            ${pkgs.findutils}/bin/xargs ${pkgs.rclone}/bin/rclone --config=${c.rcloneconf} < ${c.rcloneargs}
            echo rclone completed
          '';
        };
      } else {};
    }) cfg.configs;

    systemd.user.timers = mapAttrs' (name: c: {
      name = "rclone-${name}";
      value = if checkc c then {
        Install.WantedBy = [ "timers.target" ];
        Timer.OnCalendar = c.oncalendar;
        Unit.Description = "timer for rclone config: ${name}";
      } else {};
    }) cfg.configs;
  });
}
