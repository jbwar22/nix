{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "sway wm";
    authorizedKeys = mkOption {
      type = with types; listOf str;
      description = "list of keys that can connect to root in initrd to unlock disks";
    };
    encryptedFilesDir = mkOption {
      type = types.path;
      description = "directory where iv.bin and encrypted_host_key live";
    };
    ethernetKernelModules = mkOption {
      type = with types; listOf str;
      description = "kernel modules for initrd for ethernet";
      default = [];
    };
    tpmRegister = mkStrOption "register that holds encryption context";
    pcrStr = mkOption {
      type = types.str;
      description = "defines which pcrs are used";
      default = "sha256:0,1,7";
    };
  };
  config = mkIf cfg.enable {
    boot.initrd = {
      network = {
        enable = true;
        ssh = {
          enable = true;
          authorizedKeys = cfg.authorizedKeys;
          ignoreEmptyHostKeys = true;
          extraConfig = ''
            HostKey /etc/ssh/decrypted_host_key
          '';
        };
      };
      kernelModules = cfg.ethernetKernelModules;
      secrets = {
        "/etc/ssh/iv.bin" = "${cfg.encryptedFilesDir}/iv.bin";
        "/etc/ssh/encrypted_host_key" = "${cfg.encryptedFilesDir}/encrypted_host_key";
      };
      systemd = {
        enable = mkDefault true;
        tpm2.enable = true;
        initrdBin = with pkgs; [
          tpm2-tools
        ];
        extraBin = {
          tpm2_encryptdecrypt = "${pkgs.tpm2-tools}/bin/tpm2_encryptdecrypt";
        };
        services.sshd.preStart = ''
          tpm2_encryptdecrypt -c ${cfg.tpmRegister} -p pcr:${cfg.pcrStr} -t /etc/ssh/iv.bin -d -o /etc/ssh/decrypted_host_key /etc/ssh/encrypted_host_key
          chmod 400 /etc/ssh/decrypted_host_key
        '';
        users.root.shell = "/bin/systemd-tty-ask-password-agent";
      };
    };

    networking.interfaces.${config.custom.common.opts.hardware.interface.ethernet}.useDHCP = true;
  };
}
