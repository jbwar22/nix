{ inputs, pkgs, ns, ... }:

ns.enable {
  home.packages = [
    (inputs.wrappers.lib.wrapPackage ({ ... }: {
      inherit pkgs;
      package = pkgs.discord;
      flagSeparator = "=";
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
    }))
  ];

  custom.home.behavior.impermanence.paths = [ ".config/discord" ];
}
