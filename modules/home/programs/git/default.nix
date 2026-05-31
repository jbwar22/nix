{ pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    git-crypt
  ];

  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      signByDefault = true;
    };
    settings = {
      init.defaultBranch = "main";
      alias = let
        loggFlags = "--graph --pretty=tformat:'%Cred%h %Cgreen%cd %C(bold blue)%an%Creset%C(yellow)%d%Creset %s' --date=short";
      in {
        logg = "log ${loggFlags}";
        flogg = "log ${loggFlags} --all";
        reflogg = "log --reflog ${loggFlags} --all";
        bigblame = "! git ls-files | xargs -n1 git blame --line-porcelain 2>/dev/null | sed -n 's/^author //p' | sort -f | uniq -ic | sort -nr";
      };
    };
  };
}
