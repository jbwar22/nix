{ ns, config, lib, pkgs, ... }:

let
  inherit (ns)
  ecfg
  eopt
  cfg;
  inherit (lib)
  mkIf
  mkOption
  types;
  inherit (pkgs)
  coreutils
  dante
  iproute2
  iptables
  procps
  writeShellScript
  writeShellScriptBin
  writeText;
  inherit (cfg)
  defaultmetric
  dummyip
  prio
  socksip
  socksport
  table
  tun
  unreachablemetric;

  mkStrOptionDefault = default: description: mkOption {
    inherit default description;
    type = types.str;
  };

  ip = "${iproute2}/bin/ip";

in {
  options = eopt {
    socksip = mkStrOptionDefault "10.99.99.1" "ip to use as socks external";
    dummyip = mkStrOptionDefault "10.99.98.1" "dummy host scope ip on tun";
    tun = mkStrOptionDefault "tun5" "interface name for openvpn";
    table = mkStrOptionDefault "100" "table for routing";
    prio = mkStrOptionDefault "100" "routing prio for table lookup";
    defaultmetric = mkStrOptionDefault "100" "tun table route metric";
    unreachablemetric = mkStrOptionDefault "4000" "unreachable metric (should be > defaultmetric)";
    socksport = mkStrOptionDefault "5682" "socks server port";
  };

  config = ecfg {
    systemd.services = {
      openvpn-socks-networking = {
        description = "bring up ip and interface for openvpn-socks";
        requiredBy = [ "openvpn-socks-dante.service" ];
        after = mkIf config.networking.firewall.enable [ "firewall.service" ];
        before = [ "network-pre.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = writeShellScript "openvpn-socks-networking-start" ''
            ${ip} addr add ${socksip}/32 dev lo
            ${ip} tuntap add dev ${tun} mode tun
            ${procps}/bin/sysctl -qw net.ipv4.conf.${tun}.ignore_routes_with_linkdown=1
            ${ip} addr add ${dummyip}/32 scope host dev ${tun}
            ${ip} link set ${tun} up
            ${ip} rule add from ${socksip} lookup ${table} priority ${prio}
            ${ip} route add default dev ${tun} metric ${defaultmetric} table ${table}
            ${ip} route add unreachable default metric ${unreachablemetric} table ${table}
            ${iptables}/bin/iptables -t nat -A POSTROUTING -s ${socksip} -o ${tun} -j MASQUERADE
          '';
          ExecStop = writeShellScript "openvpn-socks-networking-stop" ''
            ${iptables}/bin/iptables -t nat -D POSTROUTING -s ${socksip} -o ${tun} -j MASQUERADE
            ${ip} rule del from ${socksip} lookup ${table} priority ${prio}
            ${ip} route flush table ${table}
            ${ip} tuntap del dev ${tun} mode tun
            ${ip} addr del ${socksip}/32 dev lo
          '';
        };
      };

      openvpn-socks-dante = let
        confFile = writeText "openvpn-socks-dante-sockd.conf" ''
          user.privileged: root
          user.unprivileged: dante
          logoutput: syslog
          internal: 127.0.0.1 port = ${socksport}
          external: ${socksip}
          socksmethod: none
          client pass { from: 127.0.0.1/32 to: 0.0.0.0/0 }
          socks pass { from: 127.0.0.1/32 to: 0.0.0.0/0 }
        '';
      in {
        description = "dante socks server for openvpn-socks";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${dante}/bin/sockd -f ${confFile}";
          ExecStop = "${coreutils}/bin/kill -HUP $MAINPID";
          Restart = "on-failure";
        };
      };
    };

    # don't create dante user/group if normal dante cfg is enabled (which would create the user)
    users = mkIf (!config.services.dante.enable) {
      users.dante = {
        description = "Dante SOCKS proxy daemon user";
        isSystemUser = true;
        group = "dante";
      };
      groups.dante = { };
    };

    environment.systemPackages = [
      (writeShellScriptBin "openvpn-socks" ''
        openvpn --config "$1" --dev ${tun} --route-nopull --persist-tun
      '')
    ];
  };
}
