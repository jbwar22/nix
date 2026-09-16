{ clib, ... }:

{
  plugins.aerial = {
    enable = false;
    settings = {
      attach_mode = "global";
    };
  };
  
  keymaps = [
    (clib.nv.mkMap "<leader>a" ":AerialToggle float<CR>")
    (clib.nv.mkMap "<leader>A" ":AerialToggle<CR>")
  ];
}
