{ ns, pkgs, ... }:

ns.enable {
  environment.systemPackages = with pkgs; [
    libpwquality
  ];
  security.pam.services.passwd.rules.password.pwquality = {
    control = "required";
    modulePath = "${pkgs.libpwquality.lib}/lib/security/pam_pwquality.so";
    order = 0;
    settings = {
      minlen = 12;
      enforce_for_root = true;
    };
  };

}
