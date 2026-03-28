{ ns, ...}:

ns.enable {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
