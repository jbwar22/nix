{ lib, pkgs, ns, ... }:

with lib; with ns; {
  options = eopt {
    rnnoise.enable = mkEnableOption "rnnoise denoising for input";
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = mkMerge [{
      enable = true;
      audio.enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
    } (mkIf cfg.rnnoise.enable {
      extraLadspaPackages = [ pkgs.rnnoise-plugin ];
      extraConfig.pipewire."99-input-denoising" = {
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "ncs";
              "media.name" = "ncs";
              "filter.graph" = {
                nodes = [
                  {
                    type = "ladspa";
                    name = "rnnoise";
                    plugin = "librnnoise_ladspa";
                    label = "noise_suppressor_mono";
                    control = {
                      "VAD Threshold (%)" = 50.0;
                      "VAD Grace Period (ms)" = 200;
                      "Retroactive VAD Grace (ms)" = 0;
                    };
                  }
                ];
              };
              "capture.props" = {
                "node.name" = "capture.rnnoise_source";
                "node.passive" = true;
                "audio.rate" = 48000;
              };
              "playback.props" = {
                "node.name" = "rnnoise_source";
                "media.class" = "Audio/Source";
                "audio.rate" = 48000;
                "filter.smart" = true;
                "filter.smart.name" = "rnnoise";
              };
            };
          }
        ];
      };
    })];
  };
}
