{ config, clib, ns, ... }:

let
  inherit (clib)
  getAdmins
  setUserGroups;

  admins = getAdmins config.custom.common.opts.host.users;
in ns.enable {
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
  users = setUserGroups admins [ "tss" ];
}
