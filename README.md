# jbwar22's nix flake

## Outputs

nixosConfigurations: `nixos-rebuild switch --flake .#HOSTNAME`
- one per host

homeConfigurations: `home-manager switch --flake .#HOSTNAME-USERNAME`
- one per host-user pair, including both nixos and non-nixos hosts

packages: `nix run .#PACKAGE`
- nixvim - nvim configured with my nixvim configuration

apps: `nix run .#APP`
- monstro-memory - example app echoing a config value (memory in gb) from a home configuration (monstro-jackson) which in turn pulls from a host configuration (monstro)


## Design

Philosophy behind the structure of my flake:
- Options should be dry, don't define the same behavior twice, even between NixOS and Home Manager
- A NixOS host should be aware of its Home Manager users and which options they have set, and make
  changes to its own configuration accordingly
- The state of the NixOS host should be able to directly affect the state of the Home Manager users
  that exist on it
- A Home Manager configuration specific to a user must be usable standalone - it should in no way
  require being on a NixOS system
- The NixOS host should make no assumptions as to what modules the Home Manager user imports

This philosophy leads to the these structures:
- Mechanism for sharing option definitions between every NixOS host and every Home Manager user
- Easy method of setting said shared options for Home Manager users when they're not on a NixOS host
- Ease of checking Home Manager users' configurations from the NixOS side in order to change the
  configuration of the host
