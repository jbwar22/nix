{ ... }:

{
  config = {
    custom.common = {
      opt.hardware = {
        cpu.threads = 12;
        memory.size = 32;
        nvidia = true;
      };
    };
  };
}
