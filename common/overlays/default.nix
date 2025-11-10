inputs: channels: system: pkgs: lib: [
  inputs.nur.overlays.default
  (import ./unstable.nix channels)
  (import ./custom.nix inputs)
  (import ./scripts.nix)
]
