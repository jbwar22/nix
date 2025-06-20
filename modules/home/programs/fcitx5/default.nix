{ inputs, pkgs, config, lib, ... }:

with lib; with ns config ./.; let
  colorscheme = config.custom.home.opts.colorscheme;
in {
  options = opt {
    enable = mkEnableOption "fcitx5 (japanese ime)";
    basic = mkEnableOption "don't set configuration";
    user-dictionary = mkOption {
      description = "path to user_dictionary.db file";
      type = with types; nullOr str;
      default = null;
    };
  };

  config = mkIf cfg.enable {

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = [
        pkgs.fcitx5-mozc
        pkgs.fcitx5-gtk
        (pkgs.callPackage ./theme { colorscheme = colorscheme.ime; })
      ];
    };

    xdg.configFile = mkIf (!cfg.basic) {
      "fcitx5/config".source = ./config/fcitx5/config;
      "fcitx5/profile" = {
        source = ./config/fcitx5/profile;
        force = true;
      };
      "fcitx5/conf/mozc.conf".source = ./config/fcitx5/conf/mozc.conf;
      "fcitx5/conf/classicui.conf".source = ./config/fcitx5/conf/classicui.conf;
      "mozc/config1.db".source = ./config/mozc/config1.db;
      "mozc/user_dictionary.db".source = mkIf (cfg.user-dictionary != null) (config.lib.file.mkOutOfStoreSymlink cfg.user-dictionary);
    };

    custom.home.behavior.impermanence.dirs = [ ".config/mozc" ];

    home.packages = mkIf (!cfg.basic) (let
      hconf = config.xdg.configHome;
      dict = cfg.user-dictionary != null;
    in [
      (pkgs.writeShellScriptBin "fcitx5-edit-config" ''
        echo WARNING! This will break home-manager rebuilds!
        echo Make sure to run fcitx5-save-and-restore-config when you are done!
        mv ${hconf}/fcitx5/config ${hconf}/fcitx5/config.bak
        mv ${hconf}/fcitx5/profile ${hconf}/fcitx5/profile.bak
        mv ${hconf}/fcitx5/conf/mozc.conf ${hconf}/fcitx5/conf/mozc.conf.bak
        mv ${hconf}/fcitx5/conf/classicui.conf ${hconf}/fcitx5/conf/classicui.conf.bak
        mv ${hconf}/mozc/config1.db ${hconf}/mozc/config1.db.bak
        ${
          if dict then ''
            mv ${hconf}/mozc/user_dictionary.db ${hconf}/mozc/user_dictionary.db.bak
          '' else ""
        }
        cp ${hconf}/fcitx5/config.bak ${hconf}/fcitx5/config
        cp ${hconf}/fcitx5/profile.bak ${hconf}/fcitx5/profile
        cp ${hconf}/fcitx5/conf/mozc.conf.bak ${hconf}/fcitx5/conf/mozc.conf
        cp ${hconf}/fcitx5/conf/classicui.conf.bak ${hconf}/fcitx5/conf/classicui.conf
        cp ${hconf}/mozc/config1.db.bak ${hconf}/mozc/config1.db
        ${
          if dict then ''
            cp ${hconf}/mozc/user_dictionary.db.bak ${hconf}/mozc/user_dictionary.db
          '' else ""
        }
        chmod +w ${hconf}/fcitx5/config
        chmod +w ${hconf}/fcitx5/profile
        chmod +w ${hconf}/fcitx5/conf/mozc.conf
        chmod +w ${hconf}/fcitx5/conf/classicui.conf
        chmod +w ${hconf}/mozc/config1.db
        ${
          if dict then ''
            chmod +w ${hconf}/mozc/user_dictionary.db
          '' else ""
        }
      '')
      (pkgs.writeShellScriptBin "fcitx5-save-and-restore-config" ''
        cp ${hconf}/fcitx5/config /etc/nixos/modules/home/programs/fcitx5/fcitx5/config
        cp ${hconf}/fcitx5/profile /etc/nixos/modules/home/programs/fcitx5/fcitx5/profile
        cp ${hconf}/fcitx5/conf/mozc.conf /etc/nixos/modules/home/programs/fcitx5/fcitx5/conf/mozc.conf
        cp ${hconf}/fcitx5/conf/classicui.conf /etc/nixos/modules/home/programs/fcitx5/fcitx5/conf/classicui.conf
        cp ${hconf}/mozc/config1.db /etc/nixos/modules/home/programs/fcitx5/mozc/config1.db
        ${
          if dict then ''
            pushd /etc/nixos/secrets/agenix/users/${config.home.username}/common > /dev/null
              ${inputs.agenix.packages.${pkgs.system}.default}/bin/agenix -e fcitx5-mozc-user_dictionary.age \
              < ${hconf}/mozc/user_dictionary.db
            popd > /dev/null
          '' else ""
        }
        rm ${hconf}/fcitx5/config
        rm ${hconf}/fcitx5/profile
        rm ${hconf}/fcitx5/conf/mozc.conf
        rm ${hconf}/fcitx5/conf/classicui.conf
        rm ${hconf}/mozc/config1.db
        ${
          if dict then ''
            rm ${hconf}/mozc/user_dictionary.db
          '' else ""
        }
        mv ${hconf}/fcitx5/config.bak ${hconf}/fcitx5/config
        mv ${hconf}/fcitx5/profile.bak ${hconf}/fcitx5/profile
        mv ${hconf}/fcitx5/conf/mozc.conf.bak ${hconf}/fcitx5/conf/mozc.conf
        mv ${hconf}/fcitx5/conf/classicui.conf.bak ${hconf}/fcitx5/conf/classicui.conf
        mv ${hconf}/mozc/config1.db.bak ${hconf}/mozc/config1.db
        ${
          if dict then ''
            mv ${hconf}/mozc/user_dictionary.db.bak ${hconf}/mozc/user_dictionary.db
          '' else ""
        }
      '')
    ]);
  };
}
