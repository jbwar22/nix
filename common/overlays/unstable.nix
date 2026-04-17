channels: final: prev: {
  inherit (channels.unstable)

  # only in unstable
  librepods

  # replace stable with unstable
  tailscale       # features
  umu-launcher    # features
  jigmo           # CJK Extension J support

  # for further overriding in custom.nix
  dunst
  sway
  sway-unwrapped
  waybar
  xdg-desktop-portal-wlr
  xscreensaver
  yt-dlp
  ;

  # for referencing packages that do not need to be unstable system-wide
  unstable = channels.unstable;
}
