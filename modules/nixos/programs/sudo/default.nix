{ lib, ns, ... }:

let
  inherit (ns)
  cfg
  opt;
  inherit (lib)
  mkEnableOption
  mkIf
  mkMerge
  mkOption
  types;
in {
  options = opt {
    bee = mkEnableOption "bee careful with sudo";
    lecture = mkOption {
      type = types.enum [ "always" "never" "once" ];
      description = "sudo lecture frequency";
      default = "once";
    };
  };
  config = {
    security.sudo.extraConfig = mkMerge [
      (mkIf cfg.bee "Defaults lecture_file = ${./bee.txt}")
      "Defaults lecture = ${cfg.lecture}"
    ];
  };
}
