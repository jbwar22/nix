{ config, clib, ... }:

{
  imports = with clib; allAugmentNamespaceArg config (
    getDirsFilter ./. (name: name != "hosts")
  );
}
