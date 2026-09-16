{ lib, pkgs, ns, ... }:

ns.enable (let
  inherit (lib)
  getExe'
  join
  mapAttrs
  mapAttrsToList;
  inherit (pkgs)
  writers
  discord
  writeShellScript
  rsync
  findutils;
  inherit (pkgs.python3Packages)
  capstone
  pyelftools;

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
  argsList = mapAttrsToList (n: v:
    if (v == true) then n else "${n}=${v}"
  ) flags;
  argsString = join " " argsList;

  discordPatcher = writers.writePython3Bin "krisp-patcher-python" {
    libraries = [ capstone pyelftools ];
    flakeIgnore = [
      "E501" # line too long (82 > 79 characters)
      "F403" # ‘from module import *’ used; unable to detect undefined names
      "F405" # name may be undefined, or defined from star imports: module
    ];
  } (builtins.readFile ./krisp-patcher.py);

  # from https://github.com/NixOS/nixpkgs/pull/538735
  # almost no confidence this works long term
  patchedDiscord = (discord.overrideAttrs (old: {
    # use rsync to copy modules instead of symlinking
    # see nixpkgs discord package for original implementation
    stageModules = writeShellScript "discord-stage-mine" ''
      # ${old.stageModules} "$@"
      store_modules="$1"
      modules_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/discord/${old.version}/modules"

      mkdir -p "$modules_dir"
      for m in "$store_modules"/*; do
        dest="$modules_dir/$(basename "$m")"

        if [ -L "$dest" ]; then
          rm "$dest"
        fi

        ${getExe' rsync "rsync"} -a --checksum --delete "$m/" "$dest"
      done

      chmod -R u+w "$modules_dir"

      echo '${
        builtins.toJSON (mapAttrs (_: mod: { installedVersion = mod; }) old.passthru.moduleVersions)
      }' \
        > "$modules_dir/installed.json"
    '';

    # fix krisp in nix store modules
    postFixup = (old.postFixup or "") + ''
      ${findutils}/bin/find "$out/opt/Discord/modules" \
        -name 'discord_krisp.node' -exec ${discordPatcher}/bin/krisp-patcher-python {} \;
    '';
  })).override {
    commandLineArgs = argsString;
  };
in {
  home.packages = [ patchedDiscord ];
  custom.home.behavior.impermanence.paths = [ ".config/discord" ];
})
