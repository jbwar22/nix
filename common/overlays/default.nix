inputs: channels: system: pkgs: lib: clib: [
  (import ./unstable.nix channels clib)
  (import ./custom.nix inputs)
  (import ./scripts.nix)
]
