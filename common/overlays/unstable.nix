channels: final: prev: {
  inherit (channels.unstable)

  # replace stable with unstable
  sway-unwrapped

  ;

  # for referencing packages that do not need to be unstable system-wide
  unstable = channels.unstable;


  # other channels

  # #506089 (1/2) krisp patch
  discord = channels.discord.discord;
}
