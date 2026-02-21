{ ... }:

{
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        rm = "safe-rm";
      };
    };
    gnupg.agent.enable = true;
    steam = {
      enable = true;
    };
  };
}
