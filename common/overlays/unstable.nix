channels: final: prev: {
  inherit (channels.unstable)
  dunst           # for overriding with my up-to-date fork
  firefox         # up-to-date browsers
  gimp3           # not in stable
  kitty           # to fix fcitx5 issue
  librewolf       # up-to-date browsers
  qbittorrent     # features 
  sway            # IM support
  swaybg          # match sway
  swaylock        # match sway
  tofi;           # .desktop entry bug
  # yt-dlp;         # features

  linuxPackages_latest_unstable = channels.unstable.linuxPackages_latest;
}
