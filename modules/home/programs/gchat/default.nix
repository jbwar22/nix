{ inputs, pkgs, ns, ... }:

ns.enable {
  home.packages = [
    (inputs.wrappers.lib.wrapPackage ({ ... }: {
      inherit pkgs;
      package = pkgs.google-chat-linux;
      flagSeparator = "=";
      flags = {
        "--wayland-text-input-version" = "3";
        "--ozone-platform" = "wayland";
      };
    }))
  ];

  custom.home.behavior.impermanence.paths = [ ".config/google-chat-linux" ];
}
