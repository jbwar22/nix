channels: final: prev: {
  inherit (channels.unstable)
  dunst           # for overriding with my up-to-date fork
  firefox         # up-to-date browsers
  kitty           # 0.42.1 segfaulting
  librewolf       # up-to-date browsers
  qbittorrent     # features 
  xscreensaver;   # wayland

  linuxPackages_latest_unstable = channels.unstable.linuxPackages_latest;

  mesa_unstable = channels.unstable.mesa;
}
