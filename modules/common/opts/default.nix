{ lib, ... }:

with lib; {
  imports = getDirs ./.;
}
