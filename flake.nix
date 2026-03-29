{
  description = "jbwar22's system config, home config, and more";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nuschtosSearch.inputs.flake-utils.inputs.systems.follows = "systems";
    };
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-parts.follows = "flake-parts";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    clonck = {
      url = "github:jbwar22/clonck";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    mavica-scripts = {
      url = "github:jbwar22/mavica-scripts";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    jbwar22-mpv-scripts = {
      url = "github:jbwar22/mpv-scripts";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-stable";
    };
    jbwar22-dunst = {
      url = "github:jbwar22/dunst";
      flake = false;
    };
    framework-dsp = {
      url = "github:cab404/framework-dsp";
      flake = false;
    };
  };

  outputs = inputs@{ self, ... }: let
    channels = {
      stable = inputs.nixpkgs-stable;
      unstable = inputs.nixpkgs-unstable;
    };
    nixpkgs-main = "stable";
    lib = channels.${nixpkgs-main}.lib;
    clib = import ./common/lib.nix lib;
  in with lib; with clib.flake-helpers; let
    hosts = fixHosts (import ./common/hosts.nix clib.enums);
    nixos-hosts = getNixosHosts hosts;

    importChannelsForSystem = system: rec {
      imported-channels = mapAttrs (_name: channel: import channel {
        inherit system;
        overlays = [ (getConfigurationRevisionOverlay channel) ]; # TODO remove
        config.allowUnfreePredicate = pkg: elem (getName pkg) (import ./common/unfree.nix); # TODO remove
      }) channels;
      pkgs = imported-channels.${nixpkgs-main};
    };

    genHMModules = hostname: username: [
      ./modules/home/users/common
      ./modules/home/users/${username}
      ./modules/home/users/${username}/${hostname}
      { home.username = mkDefault username; }
    ];
  in rec {
    nixosConfigurations = forAllHostnames nixos-hosts (hostname: let
      inherit (importChannelsForSystem host.system) imported-channels pkgs;
      host = hosts.${hostname};
      system = nixosSystem {
        inherit pkgs; # TODO remove
        specialArgs = { inherit self inputs clib; };
        modules = [
          ./modules/nixos/hosts/common
          ./modules/nixos/hosts/${hostname}
          {
            custom.common.opts.host = host;
            nixpkgs.hostPlatform = host.system;
            nixpkgs.overlays = import ./common/overlays inputs imported-channels host.system pkgs pkgs.lib;
            home-manager = {
              useGlobalPkgs = true;
              extraSpecialArgs = { inherit inputs clib self; };
              users = genAttrs (attrNames host.users) (username: {
                imports = genHMModules hostname username;
              });
            };
          }
        ];
      };
    in system);

    homeConfigurations = forAllHostUserPairs (genHostUserPairs hosts) (hostname: username: let
      inherit (importChannelsForHostname hostname) imported-channels pkgs;
      host = hosts.${hostname};
    in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs clib self;
          osConfig = if isNixosHost host then nixosConfigurations.${hostname}.config else false;
        };
        modules = (genHMModules hostname username) ++ [(if isNixosHost host then {
          nixpkgs.overlays = import ./common/overlays inputs imported-channels host.system pkgs pkgs.lib; # TODO remove
        } else ./modules/home/users/common/${hostname})];
      }
    );

    packages = genAttrs [ "x86_64-linux" ] (system: let
      pkgs = channels.${nixpkgs-main}.legacyPackages.${system};
      nixvim-package = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        module = import ./modules/nixvim;
        extraSpecialArgs = { inherit inputs clib self; };
      };
    in {
      nixvim = nixvim-package;
      impermanence-check = (import ./other/impermanence-check.nix) self pkgs;
    });
  };
}
