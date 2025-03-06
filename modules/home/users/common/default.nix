{ inputs, lib, config, ... }:

with lib; {
  imports = [
    inputs.agenix.homeManagerModules.default
    ../../../common
    ../..
  ];

  config = {
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
