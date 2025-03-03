{ lib, ... }:

with lib; {
  imports = getFilesFilter ./. (name: name != "default.nix");
}
