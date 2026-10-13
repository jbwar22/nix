inputs: clib: final: prev: {
  # regex replace nix store paths with /n/s/ to shorten lines
  btop = (prev.btop.overrideAttrs {
    patches = [
      ./patches/btop-nix-store-replace.patch
    ];
  }).override {
    cudaSupport = true;
    rocmSupport = true;
  };

  # scripts hack to allow sending signals while muted
  dunst = (prev.dunst.overrideAttrs (oldAttrs: {
    src = inputs.jbwar22-dunst;
  })).override { withX11 = false; };

  # fix gamescope not shutting down properly
  # remove when https://github.com/ValveSoftware/gamescope/pull/1908 is merged
  gamescope = prev.gamescope.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      (final.fetchpatch {
        url = "https://github.com/zlice/gamescope/commit/fa900b0694ffc8b835b91ef47a96ed90ac94823b.diff";
        hash = "sha256-eIHhgonP6YtSqvZx2B98PT1Ej4/o0pdU+4ubdiBgBM4=";
      })
    ];
  });

  # keep cursor active when hidden
  sway = (prev.sway.override {
    sway-unwrapped = prev.sway-unwrapped.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches ++ [
        ./patches/sway-hidecursor.patch
      ];
      preConfigure = ''
        substituteInPlace sway.desktop --replace "Exec=sway" "Exec=sway --unsupported-gpu"
      '';
    });
  });

  # allow icon (bar) format for disk module
  waybar = (prev.waybar.overrideAttrs (oldAttrs: {
    patches = [
      ./patches/waybar-diskicon.patch
    ];
  })).override {
    cavaSupport = false;
    mpdSupport = false;
  };

  # allow negative coordinates for screens
  xscreensaver = prev.xscreensaver.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      ./patches/xscreensaver-no-offscreen.patch
    ];
  });

  linuxPackages_rtwdebug = clib.untilReaches final.linuxPackages_latest.kernel "7.3" (final.linuxPackagesFor (
    final.linuxKernel.kernels.linux_7_2.override (let
      urlVersion = "7.3-rc7";
      realVersion = "7.3.0-rc7";
    in {
      argsOverride = {
        version = realVersion;
        modDirVersion = realVersion;
        src = final.fetchurl {
          url = "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-${urlVersion}.tar.gz";
          hash = "sha256-94n8DXs3E7a+IyhPKpw1v0H7hnhbJM/MUGwg2P9xJSM=";
        };
        structuredExtraConfig = let
          inherit (final.lib.kernel)
          yes;
        in {
          RTW89_DEBUG = yes;
          RTW89_DEBUGMSG = yes;
          RTW89_DEBUGFS = yes;
        };
      };
    })
  ));
}

