{ config, clib, ... }:

{
  imports = with clib; allAugmentNamespaceArg config (getDirs ./.);
}
