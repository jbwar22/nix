{ pkgs, lib, ns, ... }:

with lib; with ns; {
  options = eopt {
    sessions = mkOption {
      type = with types; listOf package;
      description = "sessions to be used";
      default = [];
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --remember --remember-user-session";
          user = "greeter";
        };
      };
    };

    services.displayManager.sessionPackages = cfg.sessions;

    custom.nixos.behavior.impermanence.paths = [
      { path = "/var/cache/tuigreet"; origin = "local"; }
    ];
  };
}
