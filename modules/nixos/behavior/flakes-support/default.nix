{ config, lib, ...}:

with lib; mkNsEnableModule config ./. {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
