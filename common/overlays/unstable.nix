channels: final: prev: {
  inherit (channels.unstable)

  # replace stable with unstable
  sway-unwrapped
  rpcs3

  ;

  # for referencing packages that do not need to be unstable system-wide
  unstable = channels.unstable;
}
