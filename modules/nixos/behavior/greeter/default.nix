{ pkgs, lib, ns, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (lib)
  mkOption;
  inherit (lib.types)
  listOf
  package;
in {
  options = eopt {
    sessions = mkOption {
      type = listOf package;
      description = "sessions to be used";
      default = [];
    };
  };

  config = ecfg {
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
