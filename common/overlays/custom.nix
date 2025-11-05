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
}
