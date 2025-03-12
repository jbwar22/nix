{ inputs, config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "firefox";
    usePackage = with types; mkOption {
      description = "use just the package rather than configuration";
      type = bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; mkIf cfg.usePackage [
      firefox
    ];

    programs.firefox = {
      enable = !cfg.usePackage;
      package = pkgs.firefox;

      profiles = let
        # baseextensions = with channels.nur.repos.rycee.firefox-addons; [ # TODO
        #   bitwarden
        #   skip-redirect
        #   tampermonkey
        #   translate-web-pages
        #   ublock-origin
        #   yomitan
        # ];
        baseprofile = {
          extraConfig = lib.strings.concatStrings [
            # (builtins.readFile "${inputs.arkenfox-userjs}/user.js") # TODO FIX
            (builtins.readFile ./prefs.js)
          ];
          search = {
            default = "DuckDuckGo";
            privateDefault = "DuckDuckGo";
            force = true;
            engines = {
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "Home Manager Options" = {
                urls = [{
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    { name = "release"; value = "master"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@hmo" ];
              };
              "NixOS Wiki" = {
                urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nw" ];
              };
              "Google".metaData.alias = "@g";
              "Wikipedia".metaData.alias = "@w";
              "Amazon".metaData.alias = "@a";
              "Bing".metaData.hidden = true;
              "eBay".metaData.hidden = true;
            };
            order = [
              "DuckDuckGo"
              "Google"
            ];
          };
        };
      in {
        personal = baseprofile // {
          name = "Personal";
          id = 0;
        };
        asdf = baseprofile // {
          name = "";
          id = 1;
          # extensions = baseextensions ++ (with channels.nur.repos.rycee.firefox-addons; [ # TODO
          #   (buildFirefoxXpiAddon {
          #     pname = "red-theme-2";
          #     addonId = "red-theme-2@68345967";
          #     version = "2021.3.27";
          #     url = "https://addons.mozilla.org/firefox/downloads/file/3750702/red_theme_2-1.0.xpi";
          #     sha256 = "IcPg3VsYmX5fKD2h8waV1ITbTJIR1uJZbLjvil6mDdc=";
          #     meta = with lib; {
          #       description = "Red Theme";
          #       license = licenses.cc-by-30;
          #       platforms = platforms.all;
          #     };
          #   })
          # ]);
        };
      };
    };

    xdg.desktopEntries = let
      fxdesktop = {
        type = "Application";
        genericName = "Web Browser";
        comment = "Browse the World Wide Web";
        mimeType = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "application/x-xpinstall"
          "application/pdf"
        ];
        settings = {
          Keywords = "Internet;WWW;Browser;Web;Explorer";
          Terminal = "false";
        };
      };
    in {
      # firefoxp1
      firefox = fxdesktop // {
        name = "Firefox (Personal)";
        exec = "${pkgs.firefox}/bin/firefox -P Personal %u";
        noDisplay = false;
        # noDisplay = true;
      };
      # firefoxp2
      # firefoxprofile = fxdesktop // {
      #   name = "Firefox ()";
      #   exec = "${pkgs.firefox}/bin/firefox --P TMP %u";
      #   # noDisplay = true;
      # };
    };
  };
}
