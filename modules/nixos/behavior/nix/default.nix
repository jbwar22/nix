{ inputs, outputs, config, lib, ...}:

with lib; mkNsEnableModule config ./. {
  nix = let
    flake-filter = (filterAttrs (_: v: hasAttr "_type" v && v._type == "flake"));
  in rec {
    settings = {
      keep-outputs = true;
      keep-derivations = true;
      nix-path = nixPath;
    };
    channel.enable = false;
    nixPath = [
      "self=${outputs.outPath}"
      "nixpkgs=${inputs.nixpkgs-stable.outPath}"
    ] ++ pipe inputs [
      flake-filter
      (mapAttrsToList (n: v: "${n}=${v.outPath}"))
    ];
    registry = {
      self.flake = outputs;
      nixpkgs.flake = inputs.nixpkgs-stable;
    } // pipe inputs [
      flake-filter
      (mapAttrs (_: v: {
        flake = v;
      }))
    ];
  };
}
