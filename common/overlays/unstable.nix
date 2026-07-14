channels: final: prev: {
  inherit (channels.unstable)

  # replace stable with unstable
  discord # screenshare broken on stable (maybe PR #530836)
  rpcs3
  sway-unwrapped

  ;

  # for referencing packages that do not need to be unstable system-wide
  unstable = channels.unstable;
}
