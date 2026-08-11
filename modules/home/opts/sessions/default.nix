{ lib, ns, ... }:

{
  options = with lib; ns.opt (mkOption {
    type = with types; listOf package;
    description = "sessions the user expects to be avaiable at login";
    default = [];
  });
}
