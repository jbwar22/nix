{ config, clib, ns, ... }:

let
  inherit (clib)
  getAdmins
  setUserGroups;

  admins = getAdmins config.custom.common.opts.host.users;
in ns.enable {
  users = setUserGroups admins [ "dialout" ];
}
