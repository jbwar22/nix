{ config, pkgs, ns, ... }:

ns.enable {
  home.packages = [
    # I don't use this enough to justify compiling it each time I update my system
    # Therefore, I want to have it "installed" but just build it on launch
    (pkgs.writeShellScriptBin "rpcs3" (let
      gameOut = "/home/${config.home.username}/games/rpcs3/result";
    in ''
      # nix build rather than nix run to create a gcroot
      NIXPKGS_ALLOW_UNFREE=1 ${pkgs.nix}/bin/nix build --impure nixpkgs#rpcs3 --out-link ${gameOut}
      exec -a "$0" "${gameOut}/bin/rpcs3" "@"
    ''))
  ];

  custom.home.behavior.impermanence.paths = [
    ".config/rpcs3"
    { path = ".cache/rpcs3"; origin = "local"; }
  ];
}
