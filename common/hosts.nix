enums: with enums.os; { # options to generate systems from
  monstro = { # desktop
    os = nixos;
    system = "x86_64-linux";
    users = {
      jackson = {
        admin = true;
      };
    };
  };
  widow = { # laptop
    os = nixos;
    system = "x86_64-linux";
    users = {
      jackson = {
        admin = true;
      };
    };
  };
  the-forsaken = { # server (config unused, but an example of how this would work)
    os = debian;
    system = "x86_64-linux";
    users = {
      jackson = {};
    };
  };
  nix-1 = { # VM
    os = nixos;
    system = "x86_64-linux";
    users = {
      jackson = {
        admin = true;
      };
    };
  };
}
