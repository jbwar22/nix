{ config, lib, ... }:

with lib; with namespace config { nixos.behavior.sound = ns; }; {
  options = opt {
    enable = mkEnableOption "sound output via pipewire";
    minQuantum = mkOption {
      type = with types; int;
      description = "clock min quantum for low latency support";
      default = 0;
    };
  };

  config = lib.mkIf cfg.enable {

    services.pipewire = {
      enable = true;
      audio.enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
      extraConfig.pipewire = {
        "50-low-latency" = mkIf (cfg.minQuantum != 0) {
          "context.properties" = {
            "default.clock.min-quantum" = cfg.minQuantum;
          };
        };
      };
    };

    security.rtkit.enable = true;

  };
}
