inputs: channels: system: pkgs: lib: [
  (import ./unstable.nix channels)
  (import ./custom.nix inputs)
  (import ./scripts.nix)
]
