{ config, lib, clib, pkgs, ns, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (lib)
  mkDefault
  mkOption
  mkStrOption;
  inherit (lib.types)
  enum
  listOf
  path
  str;
  inherit (clib)
  mkIfElse;
  inherit (pkgs)
  openssl
  tpm2-tools
  unixtools;
in {
  options = eopt {
    authorizedKeys = mkOption {
      type = listOf str;
      description = "list of keys that can connect to root in initrd to unlock disks";
    };
    encryptedFilesDir = mkOption {
      type = path;
      description = "directory where iv.bin and encrypted_host_key live";
    };
    ethernetKernelModules = mkOption {
      type = listOf str;
      description = "kernel modules for initrd for ethernet";
      default = [];
    };
    tpmRegister = mkStrOption "register that holds encryption context";
    pcrStr = mkOption {
      type = str;
      description = "defines which pcrs are used";
      default = "sha256:0,1,7";
    };
    mode = mkOption {
      description = "0: unseal aes, 1: encryptdecrypt";
      type = enum [ 0 1 ];
      default = 0;
    };
  };
  config = ecfg {
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
        initrdBin = [
          tpm2-tools
          openssl
          unixtools.xxd
          # coreutils
        ];
        extraBin = {
          tpm2_encryptdecrypt = "${tpm2-tools}/bin/tpm2_encryptdecrypt";
          openssl = "${openssl}/bin/openssl";
          xxd = "${unixtools.xxd}/bin/xxd";
        };
        services.sshd.after = [ "tpm2.target" ];
        services.sshd.preStart = mkIfElse (cfg.mode == 0) ''
          tpm2_unseal -c ${cfg.tpmRegister} -p pcr:${cfg.pcrStr} -o /etc/ssh/wrapkey.aes

          openssl enc -d -aes-256-ctr \
          -K "$(xxd -p /etc/ssh/wrapkey.aes | tr -d '\n')" \
          -iv "$(xxd -p /etc/ssh/iv.bin | tr -d '\n')" \
          -in /etc/ssh/encrypted_host_key -out /etc/ssh/decrypted_host_key

          rm /etc/ssh/wrapkey.aes
          chmod 400 /etc/ssh/decrypted_host_key
        '' ''
          tpm2_encryptdecrypt -c ${cfg.tpmRegister} -p pcr:${cfg.pcrStr} -t /etc/ssh/iv.bin -d -o /etc/ssh/decrypted_host_key /etc/ssh/encrypted_host_key
          chmod 400 /etc/ssh/decrypted_host_key
        '';
        users.root.shell = "/bin/systemd-tty-ask-password-agent";
      };
    };

    networking.interfaces.${config.custom.common.opts.hardware.interface.ethernet}.useDHCP = true;
  };
}
