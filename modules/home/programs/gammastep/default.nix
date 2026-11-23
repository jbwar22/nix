{ ns, config, lib, pkgs, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (pkgs)
  writeShellScript;
  inherit (lib)
  mkOption;
  inherit (lib.types)
  int;
in {
  options = eopt {
    strength = mkOption {
      type = int;
      description = "color temperature at night (kelvin)";
      default = 3600;
    };
  };
  config = ecfg {
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
      temperature = {
        day = 6500;
        night = cfg.strength;
      };
    };

    custom.home.behavior.tmpfiles."gammastep-period-output" = {
      type = "f";
      path = "/tmp/sway-gammastep-output-${config.home.username}";
      mode = "1600";
      user = "${config.home.username}";
      group = "users";
      age = "-";
      argument = "none";
    };

    xdg.configFile."gammastep/hooks/log-period.sh".source = writeShellScript "gammastep-log-period-hook" ''
      case $1 in
        period-changed)
          exec echo $3 > ${config.custom.home.behavior.tmpfiles."gammastep-period-output".path}
      esac
    '';
  };
}
