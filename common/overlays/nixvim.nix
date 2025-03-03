inputs: system: pkgs: lib: final: prev: let
  nixvim-lib = lib.extend inputs.nixvim.lib.overlay;
in {
  nixvim-custom = inputs.nixvim.legacyPackages."${system}".makeNixvimWithModule {
    inherit pkgs;
    module = import ../../modules/nixvim;
    extraSpecialArgs = { inherit inputs; lib = nixvim-lib; };
  };
}
