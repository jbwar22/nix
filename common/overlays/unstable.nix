channels: final: prev: {
  inherit (channels.unstable)

  # replace stable with unstable
  firefox         # up-to-date browsers
  kitty           # 0.42.1 segfaulting
  librewolf       # up-to-date browsers
  qbittorrent     # features 

  # for further overriding in custom.nix
  dunst
  sway
  sway-unwrapped
  tailscale
  waybar
  xscreensaver
  yt-dlp
  ;

  librepods = channels.add-librepods.librepods;

  # for referencing packages that do not need to be unstable system-wide
  unstable = channels.unstable;
}
