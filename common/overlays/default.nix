inputs: channels: system: pkgs: lib: [
  inputs.nur.overlays.default
  (import ./test.nix)
  (import ./unstable.nix channels)
  (import ./nixvim.nix inputs system pkgs lib)
]
