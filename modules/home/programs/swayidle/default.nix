{ ns, lib, pkgs, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (lib)
  mkIf
  mkOption;
  inherit (lib.types)
  nullOr
  int;
in {
  options = eopt {
    sleep-timeout = mkOption {
      type = nullOr int;
      default = null;
      description = "lock timeout in seconds, or null for no lock timeout";
    };
  };
  config = ecfg {
    services.swayidle = let
      swaylock-command = "${pkgs.swaylock}/bin/swaylock -f";
    in {
      enable = true;
      events = {
        "before-sleep" = swaylock-command;
      };
      timeouts = mkIf (cfg.sleep-timeout != null) [
        { timeout = cfg.sleep-timeout; command = swaylock-command; }
      ];
    };
  };
}
