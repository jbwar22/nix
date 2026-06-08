{ inputs, lib, clib, pkgs, ns, ... }:

with lib; with ns; let
  flags = {
    "--use-gl" = "egl"; # this appears to be the one that fixes flickering
    "--wayland-text-input-version" = "3";
    "--enable-features" = "VaapiVideoDecoder,VaapiVideoEncoder";
    "--ignore-gpu-blocklist" = true;
    "--enable-gpu-rasterization" = true;
    "--enable-zero-copy" = true;
    "--disable-software-rasterizer" = true;
    "--enable-accelerated-video-decode" = true;
    "--enable-accelerated-mjpeg-decode" = true;
    "--use-vulkan" = true;
  };
in {
  options = opt {
    enable = mkEnableOption "discord";
    useNixcord = clib.mkDisableOption "true: use nixcord module to install discord. false: manually wrap nixcord package";
  };

  config = mkIf cfg.enable {
    home.packages = mkIf (!cfg.useNixcord) [
      (inputs.wrappers.lib.wrapPackage ({ ... }: {
        inherit pkgs;
        package = inputs.nixcord.packages.${pkgs.stdenv.hostPlatform.system}.discord.override {
          withKrisp = true;
        };
        flagSeparator = "=";
        inherit flags;
      }))
    ];

    programs.nixcord = mkIf cfg.useNixcord {
      enable = true;
      discord = {
        krisp.enable = true;
        commandLineArgs = mapAttrsToList (n: v:
          if (v == true) then n else "${n}=${v}"
        ) flags;
      };
      config = {
        plugins = {
          favoriteGifSearch.enable = true;
          fixYoutubeEmbeds.enable = true;
          fullSearchContext.enable = true;
          noMiddleClickPaste.enable = true;
        };
      };
    };

    custom.home.behavior.impermanence.paths = [ ".config/discord" ];
  };
}
