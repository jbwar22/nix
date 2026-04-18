inputs: final: prev: {
  # regex replace nix store paths with /n/s/ to shorten lines
  btop = prev.btop.overrideAttrs {
    patches = [
      ./patches/btop-nix-store-replace.patch
    ];
  };

  # screenshare broke with version 0.0.127
  discord = prev.discord.overrideAttrs (oldAttrs: rec {
    version = "0.0.125";
    src = final.fetchurl {
      url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      hash = "sha256-AyKUq2GJjMam2r7oQjdQBhBsTYbhVtnUaTeLP4emRIE=";
    };
  });

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
    sway-unwrapped = (prev.sway-unwrapped.override {
      wlroots_0_19 = final.unstable.wlroots_0_20;
    }).overrideAttrs (oldAttrs: rec {
      version = "1.12-rc2";
      src = final.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = version;
        hash = "sha256-oAdj1LHEIENlw/sOtp2KucwOyzz0KzyK0e3KQi6SdNg=";
      };
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

  xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (oldAttrs: rec {
    version = "0.8.2";
    src = final.fetchFromGitHub {
      owner = "emersion";
      repo = "xdg-desktop-portal-wlr";
      rev = "v${version}";
      sha256 = "sha256-HITf/hgiASWvn/z49mzS8IS1vuyXwdk1JiAOOHRSQMo=";
    };
  });

  # allow negative coordinates for screens
  xscreensaver = prev.xscreensaver.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      ./patches/xscreensaver-no-offscreen.patch
    ];
  });
}
