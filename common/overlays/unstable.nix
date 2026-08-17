channels: final: prev: {
  inherit (channels.unstable)

  # replace stable with unstable
  rpcs3
  sway-unwrapped

  ;

  # for referencing packages that do not need to be unstable system-wide
  unstable = channels.unstable;
}
