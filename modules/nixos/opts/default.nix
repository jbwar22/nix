{ clib, ... }:

{
  imports = with clib; allAugmentNamespaceArg (getDirs ./.);
}
