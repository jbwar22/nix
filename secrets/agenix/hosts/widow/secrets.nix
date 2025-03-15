let
  keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAf4yePYnemMZx1F32abtJYIWBAyw0yO3Bsp0fRp41wR" ];
in {
  "snapserver-shairport-config.age".publicKeys = keys;
}
