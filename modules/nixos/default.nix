{ config, clib, ... }:

{
  imports = clib.allAugmentNamespaceArg config (
    clib.getDirsFilter ./. (name: name != "hosts")
  );
}
