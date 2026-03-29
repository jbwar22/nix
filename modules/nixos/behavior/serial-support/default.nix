{ config, clib, ns, ... }:

with clib; ns.enable (let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  users = setUserGroups admins [ "dialout" ];
})
