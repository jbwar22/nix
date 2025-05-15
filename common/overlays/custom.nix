inputs: channels: final: prev: {
  dunst = (channels.unstable.dunst.overrideAttrs (oldAttrs: {
    src = inputs.jbwar22-dunst;
  })).override { withX11 = false; };

  yt-dlp = (channels.unstable.yt-dlp.overrideAttrs {
    src = inputs.yt-dlp;
  });

  sway = (channels.unstable.swayfx.override {
    swayfx-unwrapped = channels.unstable.swayfx-unwrapped.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches ++ [
        inputs.swayfx-hidecursor-patch
      ];
    });
  });
}
