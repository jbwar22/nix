let
  keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9z0yK5MUPo2cxKF1C7HISLPWPSuMBuYsLfC70Czg2o" ];
in {
  "snapserver-shairport-config.age".publicKeys = keys;
  "vpn-namespace-wg.conf.age".publicKeys = keys;
  "vpn-namespace-ipv4.txt.age".publicKeys = keys;
  "vpn-namespace-ipv6.txt.age".publicKeys = keys;
  "tailscale-services-env.age".publicKeys = keys;
}
