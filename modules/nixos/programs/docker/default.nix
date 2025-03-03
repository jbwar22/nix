{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.programs.docker = ns; }) cfg opt;
  admins = getAdmins config.custom.nixos.host.users;
in
{
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
