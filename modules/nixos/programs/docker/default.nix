{ config, lib, clib, ns, ... }:

let
  inherit (ns)
  ecfg
  eopt
  cfg;
  inherit (lib)
  mkEnableOption
  mkIf;
  inherit (clib)
  getAdmins
  setUserGroups;

  admins = getAdmins config.custom.common.opts.host.users;
  hasBtrfsRoot = config.fileSystems."/".fsType == "btrfs";
in {
  options = eopt {
    enableOnBoot = mkEnableOption "enable on boot";
  };
  config = ecfg {
    virtualisation.docker = {
      enable = true;
      storageDriver = mkIf hasBtrfsRoot "btrfs";
      enableOnBoot = cfg.enableOnBoot;
    };

    virtualisation.oci-containers.backend = "docker";

    users = setUserGroups admins [ "docker" ];

    custom.nixos.behavior.impermanence.paths = [ "/var/lib/docker" ];
  };
}
