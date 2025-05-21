inputs: channels: final: prev: {
  dunst = (channels.unstable.dunst.overrideAttrs (oldAttrs: {
    src = inputs.jbwar22-dunst;
  })).override { withX11 = false; };

  yt-dlp = (channels.unstable.yt-dlp.overrideAttrs {
    src = inputs.yt-dlp;
  });

  sway = (channels.stable.sway.override {
    sway-unwrapped = channels.unstable.sway-unwrapped.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches ++ [
        ./patches/sway-hidecursor.patch
      ];
    });
  });

  waybar = channels.stable.waybar.override {
    cavaSupport = false;
    hyprlandSupport = false;
    mpdSupport = false;
  };
}
