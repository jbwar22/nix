{ lib, ... }:

with lib; {
  imports = getDirsFilter ./. (name: name != "users");
}
