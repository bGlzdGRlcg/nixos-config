{ pkgs, ... }:

{
  programs = {
    gnupg.agent.enable = true;
    steam = {
      enable = true;
    };
  };
}
