{ clib, ... }:

with clib.nv; {
  plugins.gitblame = {
    enable = true;
  };
  
  keymaps = [
    (mkMap "<leader>b" ":GitBlameToggle<CR>")
  ];
}
