{ config, clib, ns, ... }:

let
  inherit (clib)
  getAdmins
  setUserGroups;
  admins = getAdmins config.custom.common.opts.host.users;
in ns.enable {
  networking.networkmanager.enable = true;

  users = setUserGroups admins [ "networkmanager" ];

  custom.nixos.behavior.impermanence.paths = [ "/etc/NetworkManager/system-connections" ];
}
