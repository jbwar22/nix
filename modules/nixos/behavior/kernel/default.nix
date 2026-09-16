{ ns, lib, pkgs, ... }:

let
  inherit (ns)
  cfg
  opt;
  inherit (lib)
  genAttrs'
  mkForce
  mkOption
  nameValuePair;
  inherit (lib.types)
  listOf
  raw;
in {
  options = opt {
    default = mkOption {
      type = raw;
      default = pkgs.linuxPackages_6_18;
      description = "default kernel to install";
    };
    extra = mkOption {
      type = listOf raw;
      default = [];
      description = "other kernels to add as specialisations";
    };
  };
  config = {
    boot.kernelPackages = cfg.default;
    specialisation = genAttrs' cfg.extra (linuxPackages:
      nameValuePair linuxPackages.kernel.version {
        configuration = {
          boot.kernelPackages = mkForce linuxPackages;
          environment.etc.specialisation.text = "kernel ${linuxPackages.kernel.version}";
        };
      }
    );
  };
}
