let
  keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSActFQOJlMsP6lRk/K5AJfvpKKubzseuIjC+XFQjf3" ];
in {
  "snapserver-shairport-config.age".publicKeys = keys;
}
