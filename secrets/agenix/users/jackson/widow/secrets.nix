let
  keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsewl953RbhwpC1Iq6vXU7LR1MTGUkzhocd/54OY34r" ];
in {
  "geolocation.age".publicKeys = keys;
  "shairport-password.age".publicKeys = keys;
  "afuse-sshfs-hosts.age".publicKeys = keys;
  "afuse-archive-dirs.age".publicKeys = keys;
}
