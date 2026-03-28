{ config, lib, ns, ...}:

with lib; ns.enable {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
