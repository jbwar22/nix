{ self, lib, ns, ... }:

{
  options = ns.opt (lib.mkOption {
    description = "colorscheme";
    type = (self.sharedOptions.colorschemes lib).types.colorscheme;
  });
}
