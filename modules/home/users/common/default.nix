{ inputs, lib, clib, config, osConfig, ... }:

let
  inherit (clib)
  loadAgeSecretsFromDir;
in {
  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.impermanence-subvolumes.homeManagerModules.impermanence-subvolumes
    ../../../common
    ../..
  ];

  config = {
    custom.common = lib.mkIf (osConfig != false) osConfig.custom.common;
    home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
    age = {
      secrets = (
        loadAgeSecretsFromDir ../../../../secrets/agenix/users/${config.home.username}/common
      ) // ( 
        loadAgeSecretsFromDir ../../../../secrets/agenix/users/${config.home.username}/${config.custom.common.opts.host.hostname}
      );
    };
  };
}
