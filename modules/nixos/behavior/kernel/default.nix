{ ns, lib, pkgs, ... }:

with lib; with ns; {
  options = opt {
    default = mkOption {
      type = types.raw;
      default = pkgs.linuxPackages_6_18;
      description = "default kernel to install";
    };
    extra = mkOption {
      type = with types; listOf raw;
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
