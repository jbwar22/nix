{ config, lib, pkgs, ...}:

with lib; mkNsEnableModule config ./. (let
  namespace = "airns";
  interfaceName = "${namespace}wg0";
  configfile = ageOrNull config "vpn-namespace-wg.conf";
  ipv4file = ageOrNull config "vpn-namespace-ipv4.txt";
  ipv6file = ageOrNull config "vpn-namespace-ipv6.txt";
in {
  systemd.services."${namespace}" = {
    description = "wg network interface";
    requires = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      LoadCredential = mkMerge [
        (mkIf (configfile != null) [ "wg.conf:${configfile}" ])
        (mkIf (ipv4file != null) [ "ipv4.txt:${ipv4file}" ])
        (mkIf (ipv6file != null) [ "ipv6.txt:${ipv6file}" ])
      ];
      ExecStart = with pkgs; writers.writeBash "wg-up" ''
        # set -e
        ${iproute2}/bin/ip netns add ${namespace}
        ${iproute2}/bin/ip link add ${interfaceName} type wireguard
        ${iproute2}/bin/ip link set ${interfaceName} netns ${namespace}
        ipv4="$(cat ''${CREDENTIALS_DIRECTORY}/ipv4.txt)"
        ${iproute2}/bin/ip -n ${namespace} address add $ipv4 dev ${interfaceName}
        ${if ipv6file != null then ''
          ipv6="$(cat ''${CREDENTIALS_DIRECTORY}/ipv6.txt)"
          ${iproute2}/bin/ip -n ${namespace} -6 address add $ipv6 dev ${interfaceName}
        '' else ""}
        ${iproute2}/bin/ip netns exec ${namespace} \
          ${wireguard-tools}/bin/wg setconf ${interfaceName} ''${CREDENTIALS_DIRECTORY}/wg.conf
        ${iproute2}/bin/ip -n ${namespace} link set ${interfaceName} up
        ${iproute2}/bin/ip -n ${namespace} route add default dev ${interfaceName}
        ${iproute2}/bin/ip -n ${namespace} -6 route add default dev ${interfaceName}
      '';
      ExecStop = with pkgs; writers.writeBash "wg-down" ''
        ${iproute2}/bin/ip -n ${namespace} route del default dev ${interfaceName}
        ${if ipv6file != null then ''
          ${iproute2}/bin/ip -n ${namespace} -6 route del default dev ${interfaceName}
        '' else ""}
        ${iproute2}/bin/ip -n ${namespace} link del ${interfaceName}
        ${iproute2}/bin/ip netns del ${namespace}
      '';
    };
  };
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "${namespace}-run" ''
      username=$(whoami)
      sudo ip netns exec ${namespace} sudo -u $username $@
    '')
  ];
})
