inputs: final: prev: {
  # regex replace nix store paths with /n/s/ to shorten lines
  btop = prev.btop.overrideAttrs {
    patches = [
      ./patches/btop-nix-store-replace.patch
    ];
  };

  # #506089 (2/2) krisp patch
  discord = prev.discord.override {
    withKrisp = true;
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
    sway-unwrapped = (prev.sway-unwrapped.override {
      wlroots_0_19 = final.unstable.wlroots_0_20;
    }).overrideAttrs (oldAttrs: rec {
      version = "1.12";
      src = final.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = version;
        hash = "sha256-OcF7jOOHhFPhM5APn5riy8S5jsEr9jALCVh9nBtD7Nk=";
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

  # allow negative coordinates for screens
  xscreensaver = prev.xscreensaver.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      ./patches/xscreensaver-no-offscreen.patch
    ];
  });
}
