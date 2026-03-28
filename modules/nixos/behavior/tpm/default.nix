{ config, lib, ns, ... }:

with lib; ns.enable (let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
  users = setUserGroups admins [ "tss" ];
})
