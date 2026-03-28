{ lib, ns, ... }:

with lib; let
  mkColor = mkOption {
    type = types.str;
    default = "#00FF00";
  };
in {
  options = ns.opt (mkOption {
    description = "colorscheme";
    type = customTypes.colorscheme;
  });
}
