{ config, clib, pkgs, ns, ... }:

ns.enable (let
  users = config.custom.common.opts.host.users;
in {
  environment.systemPackages = with pkgs; [
    librepods
  ];

  # TODO is this needed?
  users = clib.setUserGroups users [ "librepods" ];
})

