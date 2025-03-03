{ ... }:

{
  plugins.colorizer = {
    enable = true;
    settings = {
      buftypes = [ "*" "!prompt" "!popup" "!nofile" ];
      filetypes = [ "css" "sass" "scss" ];
    };
  };
}
