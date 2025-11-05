inputs: channels: final: prev: {
  # scripts hack to allow sending signals while muted
  dunst = (channels.unstable.dunst.overrideAttrs (oldAttrs: {
    src = inputs.jbwar22-dunst;
  })).override { withX11 = false; };

  # update via flake (master branch)
  yt-dlp = (channels.unstable.yt-dlp.overrideAttrs {
    src = inputs.yt-dlp;
  });

  # keep cursor active when hidden
  sway = (channels.stable.sway.override {
    sway-unwrapped = channels.unstable.sway-unwrapped.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches ++ [
        ./patches/sway-hidecursor.patch
      ];
    });
  });

  # allow icon (bar) format for disk module
  waybar = (channels.stable.waybar.overrideAttrs (oldAttrs: {
    patches = [
      ./patches/waybar-diskicon.patch
    ];
  })).override {
    cavaSupport = false;
    mpdSupport = false;
  };

  # allow negative coordinates for screens
  xscreensaver = channels.unstable.xscreensaver.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      ./patches/xscreensaver-no-offscreen.patch
    ];
  });

  # support services (until added to unstable)
  tailscale = (channels.unstable.tailscale.overrideAttrs (oldAttrs: rec {
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
    in channels.unstable.callPackage go-module-file {
      go = channels.unstable.buildPackages.go.overrideAttrs (oldAttrs: rec {
        version = "1.25.3";
        src = final.fetchurl {
          url = "https://go.dev/dl/go${version}.src.tar.gz";
          hash = "sha256-qBpLpZPQAV4QxR4mfeP/B8eskU38oDfZUX0ClRcJd5U=";
        };
      });
    };
  };
}
