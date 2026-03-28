{ config, lib, pkgs, ns, ... }:

with lib; ns.enable (let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  users = setUserGroups admins [ "dialout" ];
})
