{ ns, ... }:

ns.enable {
  custom.home = {
    programs.bash.sourcedFiles = [ "~/work/scripts/workrc" ];
    behavior.impermanence.paths = [
      "work"
      ".aws"
    ];
  };
}
