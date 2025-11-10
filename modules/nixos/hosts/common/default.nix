{ config, lib, pkgs, inputs, ... }:

with lib; {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.agenix.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.lanzaboote.nixosModules.lanzaboote
    ../..
    ../../../common
  ];

  config = let
    users = config.custom.common.opts.host.users;
    admins = getAdmins users;
  in {
    # create user accounts
    users.users = mapAttrs (username: user: {
      isNormalUser = true;
      extraGroups = mkIf user.admin [ "wheel" ];
    }) users;

    nix.settings.trusted-users = attrNames admins;

    # load common suite
    custom.nixos.suites.common.enable = true; 

    age = {
      secrets = loadAgeSecretsFromDir ../../../../secrets/agenix/hosts/${config.custom.common.opts.host.hostname};
    };
  };
}
