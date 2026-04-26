{ config, clib, ns, ...}:

ns.enable (let
  users = config.custom.common.opts.host.users;
in {
  hardware.i2c = {
    enable = true;
  };

  users = clib.setUserGroups users [ "i2c" ];
})

