channels: clib: final: prev: let
  unstableUntilReaches = clib.untilReachesBatch channels.stable channels.unstable {
  };
in unstableUntilReaches
