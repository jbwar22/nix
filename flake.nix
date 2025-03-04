{
  description = "jbwar22's system config, home config, and more";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ ... }: let
    channels = {
      stable = inputs.nixpkgs-stable;
      unstable = inputs.nixpkgs-unstable;
    };
    nixpkgs-main = "stable";
    custom-lib = import ./common/lib.nix channels.${nixpkgs-main}.lib;
  in with channels.${nixpkgs-main}.lib; with custom-lib.flake-helpers; let
    hosts = import ./common/hosts.nix custom-lib.enums;

    nixos-hosts = getNixosHosts hosts;

    importChannelsForSystem = system: rec {
      imported-channels = mapAttrs (_name: channel: import channel {
        inherit system;
        config.allowUnfreePredicate = pkg: elem (getName pkg) (import ./common/unfree.nix);
      }) channels;
      pkgs = imported-channels.${nixpkgs-main};
      custom-lib = import ./common/lib.nix pkgs.lib;
      lib = pkgs.lib.extend (_: prev: prev // custom-lib);
      pkgs-with-lib = pkgs // { inherit lib; }; # works for home-manager, not for system
    };

    importChannelsForHostname = hostname: rec {
      host = hosts.${hostname} // { inherit hostname; };
      inherit (importChannelsForSystem host.system) imported-channels pkgs custom-lib lib pkgs-with-lib;
    };

    genHMModules = hostname: username: [
      ./modules/home/users/common
      ./modules/home/users/${username}
      ./modules/home/users/${username}/${hostname}
    ];
  in rec {
    # nixos-rebuild switch --flake .#HOSTNAME
    nixosConfigurations = forAllHostnames nixos-hosts (hostname: let
      inherit (importChannelsForHostname hostname) host imported-channels pkgs lib;
    in nixosSystem {
      inherit pkgs;
      specialArgs = { inherit inputs lib; };
      modules = [
        ./modules/nixos/hosts/common
        ./modules/nixos/hosts/${hostname}
        {
          custom.nixos.host = host;
          nixpkgs.hostPlatform = host.system;
          nixpkgs.overlays = import ./common/overlays inputs imported-channels host.system pkgs lib;
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = { inherit inputs; }; # TODO remove?
          home-manager.users = genAttrs (attrNames host.users) (username: {
            imports = genHMModules hostname username;
          });
        }
      ];
    });

    # home-manager switch --flake .#HOSTNAME-USERNAME
    homeConfigurations = forAllHostUserPairs (genHostUserPairs hosts) (hostname: username: let
      inherit (importChannelsForHostname hostname) pkgs-with-lib host imported-channels pkgs lib;
    in
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-with-lib;
        extraSpecialArgs = { inherit inputs; };
        modules = (genHMModules hostname username) ++ [(if isNixosHost host then {
          nixpkgs.overlays = import ./common/overlays inputs imported-channels host.system pkgs lib;
          custom.common = nixosConfigurations.${hostname}.config.custom.common;
        } else ./modules/home/users/common/${hostname})];
      }
    );

    packages."x86_64-linux" = let
      inherit (importChannelsForSystem "x86_64-linux") pkgs lib;
      nixvim-lib = lib.extend inputs.nixvim.lib.overlay;
      nixvim-package = inputs.nixvim.legacyPackages."x86_64-linux".makeNixvimWithModule {
        inherit pkgs;
        module = import ./modules/nixvim;
        extraSpecialArgs = { inherit inputs; lib = nixvim-lib; };
      };
    in {
      nixvim = nixvim-package;
    };


    # TODO run nixvim config from here
    apps."x86_64-linux" = let
      inherit (importChannelsForSystem "x86_64-linux") pkgs-with-lib host;
      pkgs = pkgs-with-lib;
    in {
      monstro-memory = {
        type = "app";
        program = toString (
          pkgs.writeShellScript "test" ''
            ${pkgs.coreutils}/bin/echo ${toString homeConfigurations."monstro-jackson".config.custom.common.opts.hardware.memory.size}
          ''
        );
      };
    };
  };
}
