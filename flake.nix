{
  description = "jbwar22's system config, home config, and more";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
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
    jbwar22-dunst = {
      url = "github:jbwar22/dunst";
      flake = false;
    };
    yt-dlp = {
      url = "github:yt-dlp/yt-dlp/master";
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
    custom-lib = import ./common/lib.nix channels.${nixpkgs-main}.lib;
  in with channels.${nixpkgs-main}.lib; with custom-lib.flake-helpers; let
    hosts = import ./common/hosts.nix custom-lib.enums;

    nixos-hosts = getNixosHosts hosts;

    importChannelsForSystem = system: rec {
      imported-channels = mapAttrs (_name: channel: import channel {
        inherit system;
        overlays = [ (getConfigurationRevisionOverlay channel) ];
        config.allowUnfreePredicate = pkg: elem (getName pkg) (import ./common/unfree.nix);
      }) channels;
      pkgs = imported-channels.${nixpkgs-main};
      custom-lib = import ./common/lib.nix pkgs.lib;
      lib = pkgs.lib.extend (_: prev: prev // custom-lib);
    };

    importChannelsForHostname = hostname: rec {
      host = hosts.${hostname} // { inherit hostname; };
      inherit (importChannelsForSystem host.system) imported-channels pkgs custom-lib lib;
    };

    genHMModules = hostname: username: [
      ./modules/home/users/common
      ./modules/home/users/${username}
      ./modules/home/users/${username}/${hostname}
      { home.username = mkDefault username; }
    ];
  in rec {
    # nixos-rebuild switch --flake .#HOSTNAME
    nixosConfigurations = forAllHostnames nixos-hosts (hostname: let
      inherit (importChannelsForHostname hostname) host imported-channels pkgs lib;
    in nixosSystem {
      inherit pkgs;
      specialArgs = { inherit inputs lib; outputs = self; };
      modules = [
        ./modules/nixos/hosts/common
        ./modules/nixos/hosts/${hostname}
        {
          custom.common.opts.host = host;
          nixpkgs.hostPlatform = host.system;
          nixpkgs.overlays = import ./common/overlays inputs imported-channels host.system pkgs lib;
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = { inherit inputs; outputs = self; };
          home-manager.users = genAttrs (attrNames host.users) (username: {
            imports = genHMModules hostname username;
          });
        }
      ];
    });

    # home-manager switch --flake .#HOSTNAME-USERNAME
    homeConfigurations = forAllHostUserPairs (genHostUserPairs hosts) (hostname: username: let
      inherit (importChannelsForHostname hostname) host imported-channels pkgs lib;
      home-manager-lib = lib.extend (_: _: inputs.home-manager.lib);
    in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          lib = home-manager-lib;
          outputs = self;
          osConfig = nixosConfigurations.${hostname}.config;
        };
        modules = (genHMModules hostname username) ++ [(if isNixosHost host then {
          nixpkgs.overlays = import ./common/overlays inputs imported-channels host.system pkgs lib;
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
  };
}
