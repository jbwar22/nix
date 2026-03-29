{ clib, ... }:

{
  imports = clib.getFilesFilter ./. (name: name != "default.nix");
}
