channels: final: prev: {
  # inherit (channels.unstable)

  # only in unstable

  # replace stable with unstable

  # for further overriding in custom.nix

  # ;

  # for referencing packages that do not need to be unstable system-wide
  unstable = channels.unstable;


  # other channels

  # #506089 (1/2) krisp patch
  discord = channels.discord.discord;
}
