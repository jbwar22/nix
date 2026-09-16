{ config, clib,... }:

{
  imports = clib.allAugmentNamespaceArg config (clib.getDirs ./.);
}
