{ lib, ... }:

with lib.nv; {
  plugins.aerial = {
    enable = false;
    settings = {
      attach_mode = "global";
    };
  };
  
  keymaps = [
    (mkMap "<leader>a" ":AerialToggle float<CR>")
    (mkMap "<leader>A" ":AerialToggle<CR>")
  ];
}
