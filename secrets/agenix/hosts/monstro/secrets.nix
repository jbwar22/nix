let
  keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9z0yK5MUPo2cxKF1C7HISLPWPSuMBuYsLfC70Czg2o" ];
in {
  "snapserver-shairport-config.age".publicKeys = keys;
}
