{ clib, ... }:

{
  plugins.gitblame = {
    enable = true;
  };
  
  keymaps = [
    (clib.nv.mkMap "<leader>b" ":GitBlameToggle<CR>")
  ];
}
