{ config, lib, ... }:

with lib; with namespace config { nixos.programs.docker = ns; }; let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  options = opt {
    enable = mkEnableOption "docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };

    users = setUserGroups admins [ "docker" ];
  };
}
