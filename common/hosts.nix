enums: { # options to generate systems from
  monstro = { # desktop
    os = enums.os.nixos;
    system = "x86_64-linux";
    users = {
      jackson = {
        admin = true;
      };
    };
  };
  widow = { # laptop
    os = enums.os.nixos;
    system = "x86_64-linux";
    users = {
      jackson = {
        admin = true;
      };
    };
  };
  hush = {
    os = enums.os.nixos;
    system = "x86_64-linux";
    users = {
      jackson = {
        admin = true;
      };
    };
  };
  the-forsaken = { # server (config unused, but an example of how this would work)
    os = enums.os.debian;
    system = "x86_64-linux";
    users = {
      jackson = {};
    };
  };
  nix-1 = { # VM
    os = enums.os.nixos;
    system = "x86_64-linux";
    users = {
      jackson = {
        admin = true;
      };
    };
  };
}
