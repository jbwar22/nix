{ pkgs, inputs, ns, ... }:

ns.enable (let
  signal = inputs.wrappers.lib.wrapPackage ({ config, wlib, lib, ... }: {
    inherit pkgs;
    package = pkgs.signal-desktop-bin;
    flagSeparator = "=";
    flags = {
      "--wayland-text-input-version" = "3";
      "--disable-gpu" = true;
    };
  });
in {
  home.packages = [
    signal
  ];

  custom.home.behavior.impermanence.paths = [ ".config/Signal" ];
})
