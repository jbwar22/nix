pkgs: lib: config:

rec {
  # helper scripts
  select-area = (import ./select-area.nix) pkgs;
  slider = (import ./slider.nix) pkgs;
  # main scripts
  screenshot = (import ./screenshot.nix) pkgs config select-area;
  screencopy = (import ./screencopy.nix) pkgs select-area;
  fullscreenshot = (import ./fullscreenshot.nix) pkgs config;
  volume = (import ./volume.nix) pkgs slider;
  brightness = (import ./brightness.nix) pkgs slider;
  menu = (import ./menu.nix) pkgs lib config;
}
