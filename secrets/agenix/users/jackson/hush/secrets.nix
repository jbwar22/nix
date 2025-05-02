let
  keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDiOojnsKqTIJry1LND86oZe7EsGSJSwyBLK98SF0equ" ];
in {
  "geolocation.age".publicKeys = keys;
  "shairport-password.age".publicKeys = keys;
  "afuse-sshfs-hosts.age".publicKeys = keys;
  "afuse-archive-dirs.age".publicKeys = keys;
}
