{ pkgs, lib, inputs, config, ns, ... }:

ns.enable (let
  hasGaming = config.custom.home.programs.noconfig.gaming.enable;
in {
  home.packages = [
    (inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable.override {
       location = "$HOME/games/osu/prefix";
    })
  ];
  custom.home.behavior.impermanence.paths = lib.mkIf (!hasGaming) [
    "games/osu"
  ];
})
