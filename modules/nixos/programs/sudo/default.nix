{ config, lib, ... }:

with lib; with ns config ./.; {
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
