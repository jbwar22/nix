inputs: final: prev: {
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
    });
  });

  # support services (until added to unstable)
  tailscale = (prev.tailscale.overrideAttrs (oldAttrs: rec {
    version = "1.90.6";
    src = final.fetchFromGitHub {
      owner = "tailscale";
      repo = "tailscale";
      tag = "v${version}";
      hash = "sha256-Uy5HDhZTO/lydVzT/dzp8OWgaZ8ZVQo0b7lvvzXyysI=";
    };
    vendorHash = "sha256-AUOjLomba75qfzb9Vxc0Sktyeces6hBSuOMgboWcDnE=";
  })).override {
    buildGoModule = let
      go-module-file = inputs.nixpkgs-unstable + "/pkgs/build-support/go/module.nix";
    in prev.unstable.callPackage go-module-file {
      go = prev.unstable.buildPackages.go.overrideAttrs (oldAttrs: rec {
        version = "1.25.3";
        src = final.fetchurl {
          url = "https://go.dev/dl/go${version}.src.tar.gz";
          hash = "sha256-qBpLpZPQAV4QxR4mfeP/B8eskU38oDfZUX0ClRcJd5U=";
        };
      });
    };
  };

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

  # update via flake (master branch)
  yt-dlp = prev.yt-dlp.overrideAttrs {
    src = inputs.yt-dlp;
  };
}
