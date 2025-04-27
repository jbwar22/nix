inputs: channels: final: prev: {
  dunst = (channels.unstable.dunst.overrideAttrs (oldAttrs: {
    version = "1.12.2-jbwar22";
    src = final.fetchFromGitHub {
      owner = "jbwar22";
      repo = "dunst";
      rev = "88d3c0f";
      hash = "sha256-NAayendy/eBg6Yn9Knqv25Cewu2u7XHPcz4QRn6EmxU=";
    };
  })).override { withX11 = false; };

  yt-dlp = (channels.unstable.yt-dlp.overrideAttrs {
    src = inputs.yt-dlp;
  });
}
