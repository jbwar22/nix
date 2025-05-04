{ inputs, lib, config, osConfig, ... }:

with lib; {
  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.impermanence.homeManagerModules.impermanence
    ../../../common
    ../..
  ];

  config = {
    custom.common = osConfig.custom.common; # TODO unsafe on standalone hm on non nixos systems
    home.homeDirectory = mkDefault "/home/${config.home.username}";
    age = {
      secrets = (
        loadAgeSecretsFromDir ../../../../secrets/agenix/users/${config.home.username}/common
      ) // ( 
        loadAgeSecretsFromDir ../../../../secrets/agenix/users/${config.home.username}/${config.custom.common.opts.host.hostname}
      );
    };
  };
}
