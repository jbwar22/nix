{ inputs, lib, clib, pkgs, ns, ... }:

with lib; with ns; let
  flags = {
    "--use-gl" = "egl"; # this appears to be the one that fixes flickering
    "--wayland-text-input-version" = "3";
    "--enable-features" = "VaapiVideoDecoder,VaapiVideoEncoder";
    "--ignore-gpu-blocklist" = true;
    "--enable-gpu-rasterization" = true;
    "--enable-zero-copy" = true;
    "--disable-software-rasterizer" = true;
    "--enable-accelerated-video-decode" = true;
    "--enable-accelerated-mjpeg-decode" = true;
    "--use-vulkan" = true;
  };
in {
  options = opt {
    enable = mkEnableOption "discord";
    usePythonPatch = clib.mkDisableOption "patch via older python patcher";
    useNixcord = mkEnableOption "true: use nixcord module to install discord. false: manually wrap nixcord package";
    usePlugins = mkEnableOption "use vencord / plugins";
  };

  config = mkIf cfg.enable (mkMerge [
    { # shared options
      custom.home.behavior.impermanence.paths = [ ".config/discord" ];
    }
    (mkIf cfg.usePythonPatch {
      home.packages = let
        discordPatcher = pkgs.writers.writePython3Bin "krisp-patcher-python" {
          libraries = with pkgs.python3Packages; [ capstone pyelftools ];
          flakeIgnore = [
            "E501" # line too long (82 > 79 characters)
            "F403" # ‘from module import *’ used; unable to detect undefined names
            "F405" # name may be undefined, or defined from star imports: module
          ];
        } (builtins.readFile ./krisp-patcher.py);

        # from https://github.com/NixOS/nixpkgs/pull/538735
        # almost no confidence this works long term
        patchedDiscord = pkgs.discord.overrideAttrs (old: {
          # use rsync to copy modules instead of symlinking
          # see nixpkgs discord package for original implementation
          stageModules = pkgs.writeShellScript "discord-stage-mine" ''
            # ${old.stageModules} "$@"
            store_modules="$1"
            modules_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/discord/${old.version}/modules"

            mkdir -p "$modules_dir"
            for m in "$store_modules"/*; do
              dest="$modules_dir/$(basename "$m")"

              if [ -L "$dest" ]; then
                rm "$dest"
              fi

              ${lib.getExe' pkgs.rsync "rsync"} -a --checksum --delete "$m/" "$dest"
            done

            chmod -R u+w "$modules_dir"

            echo '${
              builtins.toJSON (lib.mapAttrs (_: mod: { installedVersion = mod; }) old.passthru.moduleVersions)
            }' \
              > "$modules_dir/installed.json"
          '';

          # fix krisp in nix store modules
          postFixup = (old.postFixup or "") + ''
            ${pkgs.findutils}/bin/find "$out/opt/Discord/modules" \
              -name 'discord_krisp.node' -exec ${discordPatcher}/bin/krisp-patcher-python {} \;
          '';
        });
      in [
        (inputs.wrappers.lib.wrapPackage ({ ... }: {
          inherit pkgs;
          package = patchedDiscord;
          flagSeparator = "=";
          inherit flags;
        }))
      ];
    })
    (mkIf cfg.useNixcord {
      programs.nixcord = mkIf cfg.useNixcord {
        enable = true;
        discord = {
          krisp.enable = true;
          vencord.enable = cfg.usePlugins;
          openASAR.enable = false;
          silenceNoModClientWarning = true;
          commandLineArgs = mapAttrsToList (n: v:
            if (v == true) then n else "${n}=${v}"
          ) flags;
        };
        config = mkIf cfg.usePlugins {
          plugins = {
            favoriteGifSearch.enable = true;
            fixYoutubeEmbeds.enable = true;
            fullSearchContext.enable = true;
            noMiddleClickPaste.enable = true;
          };
        };
      };
    })
  ]);
}
