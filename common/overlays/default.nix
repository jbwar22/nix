inputs: channels: system: pkgs: lib: [
  inputs.nur.overlays.default
  (import ./test.nix)
  (import ./scripts.nix)
  (import ./unstable.nix channels)
  (import ./custom.nix inputs channels)
]
