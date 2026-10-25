{ lib, pkgs, ns, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (lib)
  mkEnableOption
  mkIf
  mkMerge;
in {
  options = eopt {
    rnnoise.enable = mkEnableOption "rnnoise denoising for input";
  };

  config = ecfg {
    security.rtkit.enable = true;

    environment.etc = {
      "alsa/conf.d/60-a52-encoder.conf".source =
        pkgs.alsa-plugins + "/etc/alsa/conf.d/60-a52-encoder.conf";

      "alsa/conf.d/59-a52-lib.conf".text = ''
        pcm_type.a52 {
          lib "${pkgs.alsa-plugins}/lib/alsa-lib/libasound_module_pcm_a52.so"
        }
      '';
    };

    services.pipewire = mkMerge [{
      enable = true;
      # package = pkgs.pipewire-unstable;
      audio.enable = true;
      wireplumber.enable = true;
      # wireplumber.package = pkgs.wireplumber-unstable;
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
