{ config, pkgs, lib, clib, ns, ... }:

let
  inherit (builtins)
  attrValues;
  inherit (lib)
  hiPrio
  mapAttrs'
  nameValuePair;
  inherit (clib)
  getUsersHMPredicate;
  inherit (pkgs)
  gamescope
  libcap
  steam
  writeShellScriptBin
  ;

  users = config.custom.common.opts.host.users;
  gamingUsers = getUsersHMPredicate config users (cfg: cfg.custom.home.suites.gaming.enable);

  # fix gamescope lag bomb
  # alternative one-liner:
  # env -u LD_PRELOAD gamescope -h 1440 -H 1440 -f -- env LD_PRELOAD="$LD_PRELOAD" %command%
  ld_gamescope = writeShellScriptBin "ld_gamescope" ''
    exec \
      env \
        -u LD_PRELOAD LD_BIND_NOW=1 \
        ${gamescope}/bin/gamescope \
        -f \
        -w 2560 -W 2560 -h 1440 -H 1440 \
        --force-grab-cursor \
        -- \
        env \
          LD_PRELOAD="$LD_PRELOAD" \
          "$@"
  '';
  getLauncher = username: "/home/${username}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
in ns.enable {
  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    package = steam.override {
      extraLibraries = extraPkgs: attrValues {
        inherit (extraPkgs)
        hidapi;
      };

      # extraArgs = "--pipewire-dmabuf";
    };

    extraCompatPackages = attrValues {
      inherit (pkgs)
      proton-ge-bin;
    };

    extraPackages = attrValues {
      inherit (pkgs)
      gamemode
      mangohud;

      inherit
      gamescope
      ld_gamescope;
    };

    extest.enable = true; # steam input on wayland
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
    remotePlay.openFirewall = true;
  };

  # frame
  networking.firewall = {
    allowedTCPPortRanges = [ { from = 27036; to = 27037; } ];
    allowedUDPPortRanges = [
      { from = 27031; to = 27036; }
      { from = 10400; to = 10401; }
    ];
  };

  systemd.services = mapAttrs' (username: _: nameValuePair "steamvr-cap-sys-nice-${username}" {
    description = "SteamVR Scheduling";
    wantedBy = [ "multi-user.target" ];
    script = let
      launcher = getLauncher username;
    in ''
      if [[ -f "${launcher}" && ! -L "${launcher}" ]] \
         && [[ "$(${libcap}/bin/getcap "${launcher}")" != *cap_sys_nice* ]]; then
        ${libcap}/bin/setcap cap_sys_nice=eip "${launcher}"
      fi
    '';
    serviceConfig.Type = "oneshot";
  }) gamingUsers;

  systemd.paths = mapAttrs' (username: _: nameValuePair "steamvr-cap-sys-nice-${username}" {
    description = "Re-run when launcher updates";
    wantedBy = [ "multi-user.target" ];
    pathConfig.PathChanged = getLauncher username;
  }) gamingUsers;
}
