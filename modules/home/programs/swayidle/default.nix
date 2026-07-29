{ ns, lib, pkgs, ... }:

with lib; with ns; {
  options = eopt {
    sleep-timeout = mkOption {
      type = with types; nullOr int;
      default = null;
      description = "lock timeout in seconds, or null for no lock timeout";
    };
  };
  config = mkIf cfg.enable {
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
